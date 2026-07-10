layout(location = 0) out vec4 fragColor;
in vec4 vVertex;
in vec2 vUv;
in vec4 vColor;
uniform vec2 lower;
uniform vec2 upper;
uniform float sigma;
in vec2 vOuterSize;

uniform sampler2D u_mask;
uniform bool u_useMask;
uniform vec2 u_windowSize;
uniform vec4 u_maskRect;

float erf(float x) {
    float s = sign(x);
    float a = abs(x);
    x = 1.0 + (0.278393 + (0.230389 + 0.078108 * (a * a)) * a) * a;
    x = x * x;
    return s - s / (x * x);
}

float sdRoundedBox(in vec2 p, in vec2 b, in float r) {
    r += 4.0;
    vec2 q = abs(p) - b + r;
    return min(max(q.x, q.y), 0.0) + length(max(q, 0.0)) - r;
}

float rounded(vec2 absolute, vec2 size, vec2 absoluteDerivatives) {
    vec2 fw = max(absoluteDerivatives, 1e-7);
    vec2 halfSize = 1.0 / fw;
    float r = size.x * halfSize.x;
    float d = sdRoundedBox(absolute * halfSize, halfSize, r);
    float shape = smoothstep(0.5, -0.5, d);

    float glowWidth = 15.0;
    float innerGlow = erf(pow(max(-d, 0.0) / max(glowWidth, 1e-5), 2.0)) / sigma;

    return shape * innerGlow;
}

void main() {
    fragColor = vColor * rounded(abs(vUv * 2.0 - 1.0), vOuterSize, fwidth(vUv) * 2.0);
    if (u_useMask) {
        vec2 maskUv = (gl_FragCoord.xy - u_maskRect.xy) / u_maskRect.zw;
        fragColor *= texture(u_mask, maskUv).r;
    }
}
