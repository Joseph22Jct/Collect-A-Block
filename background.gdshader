shader_type canvas_item;

float sdStar5(in vec2 p, in float r, in float rf)
{
    const vec2 k1 = vec2(0.809016994375, -0.587785252292);
    const vec2 k2 = vec2(-k1.x,k1.y);
    p.x = abs(p.x);
    p -= 2.0*max(dot(k1,p),0.0)*k1;
    p -= 2.0*max(dot(k2,p),0.0)*k2;
    p.x = abs(p.x);
    p.y -= r;
    vec2 ba = rf*vec2(-k1.y,k1.x) - vec2(0,1);
    float h = clamp( dot(p,ba)/dot(ba,ba), 0.0, r );
    return length(p-ba*h) * sign(p.y*ba.x-p.x*ba.y);
    
    //https://iquilezles.org/articles/distfunctions2d/
}

float sdBox( in vec2 p, in vec2 b )
{
    vec2 d = abs(p)-b;
    return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
}


vec3 palette( in float t )
{
    vec3 a = vec3(1.278, 0.818, 0.338);
    vec3 b = vec3(-0.277, 0.430, -0.414);
    vec3 c = vec3(-1.312, 1.850, -2.245);
    vec3 d = vec3(1.317, 0.267, 0.747);
    return a + b*cos( 6.28318*(c*t+d) );
} //https://iquilezles.org/articles/palettes/

//Col: [[0.278 0.818 0.338] [-0.277 0.430 -0.414] [-1.312 1.850 -2.245] [0.317 0.267 0.747]], http://dev.thi.ng/gradients/


void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 iResolution = vec2(720.0,480.0);
    vec2 uv = ((fragCoord/iResolution.xy * 2.0) -1.0) ;
    vec2 uv0 = uv;
    vec3 finalColor = vec3(0.0,0.0,0.0);
    vec2 BoxSize = vec2(0.35,0.45);
    for (float i = 0.0; i<3.0; i++){
        uv*=1.8;
        uv = fract(uv);
        
        uv-=0.5;
        uv = fract(uv);
        uv-=0.5;
        //float d = sdStar5(uv,1.1, 0.4);
        float d = sdBox(uv,BoxSize);
        float freq = 12.0;

        d = cos(d*freq + TIME)/freq;
        d=abs(d);
        //d = step(0.01,d);
        d = smoothstep(0.0,0.1,d);

        d = pow(0.01/d,0.5);

        vec3 col = palette(sdBox(uv0,BoxSize) + i*.4+ TIME*.3)-0.3;

        col*=d;

        finalColor +=col;
    }
    fragColor = vec4(finalColor,1);
    
    }
	
