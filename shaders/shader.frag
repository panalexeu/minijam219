const vec2 texSize = vec2(400.0, 224.0);

const float scanline = 0.25;   // 0 = off, 0.5 = heavy dark lines
const float mask = 0.20;       // RGB stripe strength
const float bleed = 0.35;      // horizontal smear
const float boost = 1.25;      // brightness compensation
const float vignette = 0.25;   // edge darkening

vec4 effect(vec4 color, Image tex, vec2 tc, vec2 sc) {
	// horizontal bleed: sample slightly left, like a slow electron beam
	vec2 one_x = vec2(1.0 / texSize.x, 0.0);
	vec3 c  = Texel(tex, tc).rgb;
	vec3 cl = Texel(tex, tc - one_x * 0.5).rgb;
	vec3 base = mix(c, cl, bleed);

	// scanlines: darken the lower part of each source pixel row
	float y = fract(tc.y * texSize.y);
	float line = 1.0 - scanline * smoothstep(0.4, 1.0, y);

	// aperture mask: tint alternating screen columns R / G / B
	float col = mod(sc.x, 3.0);
	vec3 stripe = vec3(1.0 - mask);
	if (col < 1.0)      stripe.r = 1.0 + mask;
	else if (col < 2.0) stripe.g = 1.0 + mask;
	else                stripe.b = 1.0 + mask;

	vec3 result = base * line * stripe * boost;

	// vignette
	vec2 d = tc - 0.5;
	result *= 1.0 - dot(d, d) * vignette * 4.0;

	return vec4(result, 1.0) * color;
}