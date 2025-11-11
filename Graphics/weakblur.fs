extern number radius; // blur radius
extern vec2 texSize;  // texture size

vec4 effect(vec4 color, Image tex, vec2 texCoord, vec2 screenCoord) {
    vec4 sum = vec4(0.0);
    int samples = 0;

    for (int x = -4; x <= 4; x++) {
        for (int y = -4; y <= 4; y++) {
            vec2 offset = vec2(x, y) / texSize * radius;
            sum += Texel(tex, texCoord + offset);
            samples++;
        }
    }

    return sum / samples * color;
}