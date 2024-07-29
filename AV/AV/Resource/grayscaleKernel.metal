//
//  grayscaleKernel.metal
//  AV
//
//  Created by IvanDev on 28/07/2024.
//

#include <metal_stdlib>
using namespace metal;

kernel void grayscaleKernel(texture2d<float, access::read> inputTexture [[ texture(0) ]],
                            texture2d<float, access::write> outputTexture [[ texture(1) ]],
                            uint2 gid [[ thread_position_in_grid ]]) {
    float4 color = inputTexture.read(gid);
    float gray = dot(color.rgb, float3(0.299, 0.587, 0.114));
    outputTexture.write(float4(gray, gray, gray, color.a), gid);
}
