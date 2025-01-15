shader_type canvas_item;

uniform float min_range : hint_range(0, 1) = 0;
uniform float max_range : hint_range(0, 1) = 1;

vec3 rgb2hsv(vec3 c) {
    float c_max = max(max(c.r, c.g), c.b);
    float c_min = min(min(c.r, c.g), c.b);
    float delta = c_max - c_min;
    
    float h = 0.0;
    if (delta > 0.0) {
        if (c_max == c.r) {
            h = mod((c.g - c.b) / delta, 6.0);
        } else if (c_max == c.g) {
            h = ((c.b - c.r) / delta) + 2.0;
        } else {
            h = ((c.r - c.g) / delta) + 4.0;
        }
        h /= 6.0;
    }
    
    float s = (c_max > 0.0) ? delta / c_max : 0.0;
    float v = c_max;
    
    return vec3(h, s, v);
}

void fragment() {
    vec4 color = texture(TEXTURE, UV);
	
	vec3 hsv = rgb2hsv(color.rgb);
	if (hsv.x >= min_range && hsv.x <= max_range) {
		COLOR = vec4(color.rgb, color.a);
	} else {
	    float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));
		COLOR = vec4(vec3(gray), color.a);
	}
}