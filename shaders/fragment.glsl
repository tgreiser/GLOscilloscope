layout (location = 0) out vec4 fragColor;
// #version 120
#define EPS 1E-6
#define TAU 6.283185307179586
#define TAUR 2.5066282746310002
#define SQRT2 1.4142135623730951
uniform float uSize;
uniform float uIntensity;
uniform float uHue;
uniform vec3 uRgb; 
uniform float uIntensityBase;

in Vertex {
    vec4 position;
	vec4 color;
	float brightness;
    vec3 texcoord;
    vec2 pos;
} iVert;

float erf(float x) {
	float s = sign(x), a = abs(x);
	x = 1.0 + (0.278393 + (0.230389 + (0.000972 + 0.078108 * a) * a) * a) * a;
	x *= x;
	return s - s / (x * x);
}

void main ()
{
	TDCheckDiscard();
	TDAlphaTest(iVert.color.a);
	fragColor = TDOutputSwizzle(iVert.color);

	float len = iVert.texcoord.z; // we pass in length ...
	vec2 xy = iVert.texcoord.xy; // and xy through color
	float alpha;

	float sigma = uSize/(2.0+2.0*1000.0*uSize/50.0);

	// Otherwise, use analytical integral for accumulated intensity.
	alpha = erf(xy.x/SQRT2/sigma) - erf((xy.x-len)/SQRT2/sigma);
	alpha *= exp(-xy.y*xy.y/(2.0*sigma*sigma))/2.0/len*uSize;

	alpha = pow(alpha,1.0-uIntensityBase)*(0.01+min(0.99,uIntensity*3.0));
	//fragColor = vec4(uRgb, alpha*brightness);
	fragColor = vec4(iVert.color.rgb, alpha*iVert.brightness);
}