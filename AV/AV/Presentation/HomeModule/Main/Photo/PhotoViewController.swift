//
//  PhotoViewController.swift
//  AV
//
//  Created by IvanDev on 28/07/2024.
//

import UIKit
import MetalKit
import SwiftUI

final class PhotoViewController: UIViewController {
        
    var viewModel: any MainViewModelProtocol
    
    private var metalView: MTKView?
    private var metalDevice: MTLDevice?
    private var metalCommandQueue: MTLCommandQueue?
    private var metalPipelineState: MTLComputePipelineState?
    
    private var ciContext: CIContext?
    
    private var currentCIImage: CIImage? {
        didSet {
            metalView?.draw()
        }
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage())
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select photo", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, 
                         action: #selector(selectPhotoTapped),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var savePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save photo", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, 
                         action: #selector(downloadVisiblePortion),
                         for: .touchUpInside)
        return button
    }()
    
    init(viewModel: any MainViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureImageView()
        setupMetalView()
        setupLayout()
        applyBlurToBackground()
        setupMetalPipeline()
        configureMetal()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateBlurMask()
    }
}

// MARK: - Private methods

extension PhotoViewController {
    
    private func setupLayout() {
        view.backgroundColor = .white
        [imageView, selectPhotoButton, savePhotoButton].forEach { view.addSubview($0) }
        
        if let metalView = metalView {
            view.addSubview(metalView)
        }
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            selectPhotoButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0),
            selectPhotoButton.trailingAnchor.constraint(equalTo: savePhotoButton.leadingAnchor, constant: -20),
            selectPhotoButton.heightAnchor.constraint(equalToConstant: 50),
            
            savePhotoButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 0),
            savePhotoButton.leadingAnchor.constraint(equalTo: safeArea.centerXAnchor, constant: 10),
            savePhotoButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        if let metalView = metalView {
            metalView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                metalView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
                metalView.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor),
                metalView.widthAnchor.constraint(equalTo: safeArea.widthAnchor, multiplier: 0.5),
                metalView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.75)
            ])
        }
    }
    
    private func configureMetal() {
        guard let metalDevice = MTLCreateSystemDefaultDevice() else {
            fatalError("Could not instantiate required metal properties")
        }
        
        metalCommandQueue = metalDevice.makeCommandQueue()
        metalView?.device = metalDevice
        metalView?.isPaused = true
        metalView?.enableSetNeedsDisplay = false
        metalView?.framebufferOnly = false
        
        ciContext = CIContext(mtlDevice: metalDevice)
    }
    
    func getCropImage() -> UIImage? {
        guard let metalView = metalView else {
            return nil
        }

        metalView.isHidden = true

        let metalViewSize = metalView.frame.size
        let cropSize = CGSize(width: max(metalViewSize.width - 4, 0),
                              height: max(metalViewSize.height - 4, 0))

        guard let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first else { return nil }
        let center = CGPoint(x: window.bounds.midX, y: window.bounds.midY)
        let cropRect = CGRect(x: center.x - cropSize.width / 2,
                              y: center.y - cropSize.height / 2,
                              width: cropSize.width,
                              height: cropSize.height)

        UIGraphicsBeginImageContextWithOptions(cropSize, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.translateBy(x: -cropRect.origin.x, 
                            y: -cropRect.origin.y)
        window.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        metalView.isHidden = false
        
        return image
    }
    
    private func updateBlurMask() {
        if let blurEffectView = view.subviews.first(where: { $0 is UIVisualEffectView }) as? UIVisualEffectView {
            let maskLayer = CAShapeLayer()
            maskLayer.frame = blurEffectView.bounds
            let path = CGMutablePath()
            path.addRect(blurEffectView.bounds)
            if let metalView = metalView {
                path.addRect(metalView.frame)
            }
            maskLayer.path = path
            maskLayer.fillRule = .evenOdd
            
            blurEffectView.layer.mask = maskLayer
        }
    }
    
    private func applyBlurToBackground() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = blurEffectView.bounds
        let path = CGMutablePath()
        path.addRect(blurEffectView.bounds)
        if let metalView = metalView {
            path.addRect(metalView.frame)
        }
        maskLayer.path = path
        maskLayer.fillRule = .evenOdd
        
        blurEffectView.layer.mask = maskLayer
        blurEffectView.isUserInteractionEnabled = false
        view.insertSubview(blurEffectView, at: 1)
    }
    
    private func configureImageView() {
        imageView.isUserInteractionEnabled = true

        let pinchGesture = UIPinchGestureRecognizer(target: self,
                                                    action: #selector(handlePinchGesture(_:)))
        let rotationGesture = UIRotationGestureRecognizer(target: self,
                                                          action: #selector(handleRotationGesture(_:)))

        pinchGesture.delegate = self
        rotationGesture.delegate = self

        imageView.addGestureRecognizer(pinchGesture)
        imageView.addGestureRecognizer(rotationGesture)
    }
}

// MARK: - Obj-c methods

extension PhotoViewController {
    @objc private func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        guard gesture.view != nil else { return }
        
        if gesture.state == .began || gesture.state == .changed {
            gesture.view?.transform = (gesture.view?.transform.scaledBy(x: gesture.scale, y: gesture.scale))!
            gesture.scale = 1.0
        }
    }
    
    @objc private func handleRotationGesture(_ gesture: UIRotationGestureRecognizer) {
        guard let gestureView = gesture.view else { return }
        
        if gesture.state == .began || gesture.state == .changed {
            gestureView.transform = gestureView.transform.rotated(by: gesture.rotation)
            gesture.rotation = 0
        }
    }
    
    @objc private func selectPhotoTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    @objc private func downloadVisiblePortion() {
        guard let imageToSave = getCropImage() else {
            log("Failed to capture image from metal view.")
            return
        }
        viewModel.apply(.onSaveImage(imageToSave))
    }
}

// MARK: - Metal view delegate methods

extension PhotoViewController: MTKViewDelegate {
    func draw(in view: MTKView) {
        guard let ciImage = currentCIImage,
              let metalCommandQueue = metalCommandQueue,
              let currentDrawable = view.currentDrawable,
              let commandBuffer = metalCommandQueue.makeCommandBuffer() else { return }
        
        let drawSize = view.drawableSize
        let scaleX = drawSize.width / ciImage.extent.width
        let newImage = ciImage.transformed(by: .init(scaleX: scaleX, y: scaleX))
        
        ciContext?.render(newImage, to: currentDrawable.texture,
                          commandBuffer: commandBuffer,
                          bounds: CGRect(x: 0, y: 0, width: drawSize.width, height: drawSize.height),
                          colorSpace: CGColorSpaceCreateDeviceRGB())
        
        commandBuffer.present(currentDrawable)
        commandBuffer.commit()
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) { }
}

// MARK: - Metal private methods

extension PhotoViewController {
    
    private func setupMetalView() {
        metalView = MTKView()
        metalView?.backgroundColor = UIColor.clear
        metalView?.layer.borderColor = UIColor.yellow.cgColor
        metalView?.layer.borderWidth = 2.0
        metalView?.isUserInteractionEnabled = false
    }
    
    private func setupMetalPipeline() {
        metalDevice = MTLCreateSystemDefaultDevice()
        metalCommandQueue = metalDevice?.makeCommandQueue()

        let defaultLibrary = metalDevice?.makeDefaultLibrary()
        let kernelFunction = defaultLibrary?.makeFunction(name: Constants.KernelName.grayscale)
        do {
            metalPipelineState = try metalDevice?.makeComputePipelineState(function: kernelFunction!)
        } catch {
            fatalError("Unable to create pipeline state: \(error)")
        }
    }
        
    func applyGrayscaleEffect(to image: UIImage) {
        guard let cgImage = image.cgImage,
              let metalDevice = metalDevice,
              let metalCommandQueue = metalCommandQueue else { return }

        let textureLoader = MTKTextureLoader(device: metalDevice)
        
        do {
            let texture = try textureLoader.newTexture(cgImage: cgImage, 
                                                       options: nil)
            let commandBuffer = metalCommandQueue.makeCommandBuffer()
            let commandEncoder = commandBuffer?.makeComputeCommandEncoder()
            commandEncoder?.setComputePipelineState(metalPipelineState!)
            commandEncoder?.setTexture(texture, index: 0)

            let outputTexture = makeTexture(size: CGSize(width: cgImage.width, 
                                                         height: cgImage.height),
                                            device: metalDevice)
            commandEncoder?.setTexture(outputTexture, 
                                       index: 1)

            let threadGroupCount = MTLSize(width: 8, 
                                           height: 8,
                                           depth: 1)
            let threadGroups = MTLSize(width: (cgImage.width + 7) / 8,
                                       height: (cgImage.height + 7) / 8, depth: 1)
            commandEncoder?.dispatchThreadgroups(threadGroups,
                                                 threadsPerThreadgroup: threadGroupCount)
            commandEncoder?.endEncoding()

            commandBuffer?.commit()
            commandBuffer?.waitUntilCompleted()

            updateImageView(with: outputTexture)
        } catch {
            log("Error loading texture: \(error.localizedDescription)")
        }
    }
        
    private func makeTexture(size: CGSize, device: MTLDevice) -> MTLTexture {
        let descriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .rgba8Unorm,
                                                                  width: Int(size.width),
                                                                  height: Int(size.height),
                                                                  mipmapped: false)
        descriptor.usage = [.shaderRead, .shaderWrite]
        
        return device.makeTexture(descriptor: descriptor)!
    }
        
    private func updateImageView(with texture: MTLTexture) {
        var data = [UInt8](repeating: 0, 
                           count: texture.width * texture.height * 4)
        
        texture.getBytes(&data,
                         bytesPerRow: texture.width * 4,
                         from: MTLRegionMake2D(0, 0,
                                               texture.width,
                                               texture.height),
                         mipmapLevel: 0)
        
        let provider = CGDataProvider(data: Data(data) as CFData)
        
        guard let cgImg = CGImage(width: texture.width,
                            height: texture.height,
                            bitsPerComponent: 8,
                            bitsPerPixel: 32, 
                            bytesPerRow: texture.width * 4,
                            space: CGColorSpaceCreateDeviceRGB(), 
                            bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipLast.rawValue),
                            provider: provider!,
                            decode: nil,
                            shouldInterpolate: false,
                                  intent: .defaultIntent) else {return}
        
        DispatchQueue.main.async {
            self.imageView.image = UIImage(cgImage: cgImg)
        }
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate delegate methods

extension PhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
            viewModel.image = image
            applyGrayscaleEffect(to: imageView.image ?? image)
            currentCIImage = CIImage(image: image)
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: - UIGestureRecognizerDelegate delegate methods

extension PhotoViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
