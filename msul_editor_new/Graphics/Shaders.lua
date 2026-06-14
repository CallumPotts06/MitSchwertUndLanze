
--this library stores all the gsl code for shaders used in the game--
---/// LIBRARY ///---

Shaders = {}


---/// SHADER: WEAK GAUSSIAN BLUR ///---
Shaders.GaussianBlurCode = [[
extern number radius; // blur radius (control strength)
extern vec2 texSize;  // texture size

vec4 effect(vec4 color, Image tex, vec2 texCoord, vec2 screenCoord) {
    float sigma = max(0.0001, radius);
    float twoSigmaSq = 2.0 * sigma * sigma;

    vec4 sum = vec4(0.0);
    float weightSum = 0.0;

    for (int x = -4; x <= 4; x++) {
        for (int y = -4; y <= 4; y++) {
            float fx = float(x);
            float fy = float(y);

            // sample offset scaled by radius and texture size
            vec2 offset = vec2(fx, fy) / texSize * radius;

            // Gaussian weight
            float w = exp(-(fx*fx + fy*fy) / twoSigmaSq);

            vec4 sample = Texel(tex, texCoord + offset);
            sum += sample * w;
            weightSum += w;
        }
    }

    return (sum / weightSum) * color;
}
]]
Shaders.Blur = love.graphics.newShader(Shaders.GaussianBlurCode)


return Shaders