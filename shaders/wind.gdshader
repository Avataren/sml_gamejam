shader_type canvas_item;
uniform float speed = 2.0;
uniform float wind = 20.0;
uniform float height = 64.0;
uniform float fadeHeight = 0.1;
uniform float noise_scale = 100.0;
// 0: integer hash
// 1: float hash (aliasing based) (don't do this unless you live in the year 2013)
#define METHOD 0

// 0: cubic
// 1: quintic
#define INTERPOLANT 0

#if METHOD==0
float hash( in ivec2 p )  // this hash is not production ready, please
{                         // replace this by something better

    // 2D -> 1D
    int n = p.x*3 + p.y*113;

    // 1D hash by Hugo Elias
	n = (n << 13) ^ n;
    n = n * (n * n * 15731 + 789221) + 1376312589;
    return -1.0+2.0*float( n & 0x0fffffff)/float(0x0fffffff);
}
#else
float hash(vec2 p)  // replace this by something better
{
    p  = 50.0*fract( p*0.3183099 + vec2(0.71,0.113));
    return -1.0+2.0*fract( p.x*p.y*(p.x+p.y) );
}
#endif

float noise( in vec2 p )
{
    ivec2 i = ivec2(floor( p ));
    vec2 f = fract( p );
    vec2 u = f*f*(3.0-2.0*f);
    return mix( mix( hash( i + ivec2(0,0) ), 
                     hash( i + ivec2(1,0) ), u.x),
                mix( hash( i + ivec2(0,1) ), 
                     hash( i + ivec2(1,1) ), u.x), u.y);
}

void vertex() {
    // Normalized position of the vertex from the top (0.0 at the top to 1.0 at the bottom).
	vec2 worldPos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
    float normalizedHeight = VERTEX.y / height;
	float normalizedWidth = VERTEX.x / height;
    float influence = clamp(1.0 - (normalizedHeight / fadeHeight), 0.0, 1.0);
	float n = noise(vec2(worldPos.x + TIME*0.01, worldPos.y+TIME*0.01))*noise_scale * influence;
    VERTEX.x += mix(0.0, sin(TIME * speed + n) * wind, pow(influence, 2.0));
}


