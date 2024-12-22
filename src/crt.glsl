extern number time;
// float warp = 0.75;

// // https://prideout.net/barrel-distortion
// vec2 distort(vec2 p)
// {
//     float theta  = atan(p.y, p.x);
//     float radius = length(p);
//     radius = pow(radius, warp);
//     p.x = radius * cos(theta);
//     p.y = radius * sin(theta);
//     return 0.5 * (p + 1.0);
// }

// https://agatedragon.blog/2023/12/24/barrel-distortion-shader/
// The power of the barrel distortion
float power = 1.025;

vec2 BarrelDistortionCoordinates(vec2 uv) {
	// Convert tex coord to the -1 to 1 range
vec2 pos = 2.0 * uv - 1.0;

float len = length(pos);
len = pow(len, power);

pos = normalize(pos);
pos *= len;

	// Convert pos to the 0 to 1 range
pos = 0.5 * (pos + 1.0);

return pos;
}

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
    // float distance = length(screen_coords - vec2(400, 300));
texture_coords = BarrelDistortionCoordinates(texture_coords);

if(texture_coords.x < 0.0 || texture_coords.x > 1.0 || texture_coords.y < 0.0 || texture_coords.y > 1.0) {
return vec4(0.0, 0.0, 0.0, 0.0);
}

    // No warp on scanlines
float hf = abs(sin(time * 2.0 - screen_coords.y / 600.0 * 100.0)) * 0.05;
float lf = abs(sin(time * 0.5 - screen_coords.y / 600.0 * 2.0)) * 0.05;

float t = abs(sin(screen_coords.x * 100.0)) * 0.05;

    // Warp on scanlines
    // float hf = abs(sin(time * 2 - texture_coords.y * 150)) * 0.075;
    // float lf = abs(sin(time * 0.5 - texture_coords.y * 2)) * 0.05;

vec4 texturecolor = Texel(tex, texture_coords);
texturecolor = mix(texturecolor, vec4(0, 0, 0, 0), lf);
texturecolor = mix(texturecolor, vec4(0, 0, 0, 0), hf);
texturecolor = mix(texturecolor, vec4(0, 0, 0, 0), t);
return texturecolor * color;
}
