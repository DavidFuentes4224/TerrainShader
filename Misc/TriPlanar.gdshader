shader_type spatial;

uniform sampler2D TOP:source_color;
uniform sampler2D TOP_SECONDARY:source_color;
uniform sampler2D SIDE:source_color;

uniform float TextureScale : hint_range(1,20);

varying vec2 tex_position;
varying vec3 vert_position;
varying vec3 vert_normal;
varying vec3 vert_normal_IWS;

void vertex() {
	vert_position = (vec4(VERTEX,1.0) * MODEL_MATRIX).rgb / TextureScale;
	vert_normal = NORMAL ;
	vert_normal_IWS = NORMAL * MODEL_NORMAL_MATRIX;
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec3 topColor = texture(TOP, vert_position.xz).rgb;
	vec3 topSecondary = texture(TOP_SECONDARY, vert_position.xz).rgb;
	
	vec3 sideColorX = texture(SIDE, vert_position.yz).rgb * 0.8;
	vec3 sideColorZ = texture(SIDE, vert_position.xy).rgb * 0.8;
	
	vec3 normalIWS = abs(vert_normal_IWS);
	vec3 normalWeights = normalIWS / (normalIWS.x + normalIWS.y + normalIWS.z);
	
	float angle = atan(normalIWS.z, normalIWS.x);
	float blendFactor = (angle + PI) / (2.0 * PI);
	
	vec3 topWeight = mix(topColor, topSecondary, blendFactor);
	ALBEDO = (sideColorX * normalWeights.x) + (sideColorZ * normalWeights.z) + (topWeight * normalWeights.y);
	// Called for every pixel the material is visible on.
}