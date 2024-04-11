shader_type canvas_item;
varying vec2 global_pos;

#define TAU 6.28318530718
#define MAX_ITER 6
#define GAMMA 0.7
#define REGIONS 8.0

vec3 posterize(vec3 color)
{
	color = pow(color, vec3(GAMMA, GAMMA, GAMMA));
	color = floor(color * REGIONS)/REGIONS;
	color = pow(color, vec3(1.0/GAMMA));
	return color.rgb;
}


void vertex() {
	global_pos= (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;	
}

float water(vec2 uv) 
{
	float time = TIME * .25 + 29.0;
    vec2 p = mod(uv*TAU, TAU)-250.0;
	vec2 i = vec2(p);
	float c = 1.0;
	float inten = .005;

	for (int n = 0; n < MAX_ITER; n++) 
	{
		float t = time * (1.0 - (3.5 / float(n+1)));
		i = p + vec2(cos(t - i.x) + sin(t + i.y), sin(t - i.y) + cos(t + i.x));
		c += 1.0/length(vec2(p.x / (sin(i.x+t)/inten),p.y / (cos(i.y+t)/inten)));
	}
	c /= float(MAX_ITER);
	c = pow(1.17-pow(c, 1.2), 4);
	return c;
}

void fragment() {
	vec4 col = texture(TEXTURE,UV);
	if (col.b > 0.4 && col.g > 0.3)
	{
		vec2 offset = vec2(TIME * 0.06+ global_pos.x*0.0035, TIME*0.1+ global_pos.y*0.0035);
		float w = water(offset);
		vec3 final_col = posterize(mix(col.rgb,col.rgb*w,0.25));
		col=vec4(final_col,1);
	}
	COLOR = col;
}
