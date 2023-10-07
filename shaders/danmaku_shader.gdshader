shader_type canvas_item;

void fragment() {
    vec4 pixel = texture(TEXTURE, UV);
    float factor = abs(pixel.r - 0.5) * 2.0;
	float alpha = COLOR.a;
    COLOR += vec4(vec3(0.2 * sin(TIME * 12.0)), 1.0);
    COLOR = mix(COLOR, pixel, factor);
    COLOR.a = pixel.a * alpha;
}
