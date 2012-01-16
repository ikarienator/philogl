#ifdef GL_ES
precision highp float;
#endif

#define PI 3.141592654
#define PI2 (3.141592654 * 2.)

#define PATTERN_DIM 128.0

#define GROUP_P1 0
#define GROUP_P2 1
#define GROUP_PM 2
#define GROUP_PG 3
#define GROUP_CM 4
#define GROUP_PMM 5
#define GROUP_PMG 6
#define GROUP_PGG 7
#define GROUP_CMM 8
#define GROUP_P4 9
#define GROUP_P4M 10
#define GROUP_P4G 11
#define GROUP_P3 12

uniform int group;
uniform float offset;
uniform float rotation;
uniform vec2 scaling;
uniform vec2 resolution;
uniform float radialFactor;

uniform sampler2D sampler1;

void main(void) {
  vec2 pos = gl_FragCoord.xy;

  float xt =  pos.x * cos(rotation) * scaling.x + pos.y * sin(rotation) * scaling.y;
  float yt = -pos.x * sin(rotation) * scaling.x + pos.y * cos(rotation) * scaling.y;

  if (group == GROUP_P1) {
    
    float oyt = yt;
    yt = mod(yt, PATTERN_DIM) / PATTERN_DIM;
    float widthDim = PATTERN_DIM - offset;
    float from  = offset / PATTERN_DIM * yt;
    float to = 1. - offset * (1. - yt) / PATTERN_DIM;
    xt = mod(xt - offset * (oyt / PATTERN_DIM), widthDim) / widthDim * (to - from) + from;

  } else if (group == GROUP_P2) {
    
    float widthDim = PATTERN_DIM - offset;
    float oyt = yt;
    if (mod(yt / PATTERN_DIM, 2.0) < 1.0) {
      yt = mod(yt, PATTERN_DIM) / PATTERN_DIM;
      float from  = offset / PATTERN_DIM * yt;
      float to = 1. - offset * (1. - yt) / PATTERN_DIM;
      xt = mod(xt - offset * (oyt / PATTERN_DIM), widthDim) / widthDim * (to - from) + from;

    } else {
      yt = 1. - mod(yt, PATTERN_DIM) / PATTERN_DIM;
      float from  = 1. - offset / PATTERN_DIM * (1. - yt);
      float to = offset * yt / PATTERN_DIM;
      xt = mod(xt - offset * (oyt / PATTERN_DIM), widthDim) / widthDim * (to - from) + from;

    }

  } else if (group == GROUP_PM) {
    
    float heightDim = PATTERN_DIM - 2. * offset;
    float from = offset / PATTERN_DIM;
    float to = 1. - offset / PATTERN_DIM;
    xt = mod(xt, PATTERN_DIM) / PATTERN_DIM;

    if (mod(yt / heightDim, 2.0) < 1.0) {
      yt = mod(yt, heightDim) / heightDim * (to - from) + from;

    } else {
      yt = (1. - mod(yt, heightDim) / heightDim) * (to - from) + from;
    }

  } else if (group == GROUP_PG) {
    
    float heightDim = PATTERN_DIM - 2. * offset;
    float from = offset / PATTERN_DIM;
    float to = 1. - offset / PATTERN_DIM;

    if (mod(xt / PATTERN_DIM, 2.0) < 1.0) {
      yt = mod(yt, heightDim) / heightDim * (to - from) + from;

    } else {
      yt = (1. - mod(yt, heightDim) / heightDim) * (to - from) + from;
    }
    
    xt = mod(xt, PATTERN_DIM) / PATTERN_DIM;

  } else if (group == GROUP_CM) {
    
    float heightDim = PATTERN_DIM - 2. * offset;
    float from = offset / PATTERN_DIM;
    float to = 1. - offset / PATTERN_DIM;
    float xtmod = mod(xt, PATTERN_DIM) / PATTERN_DIM;
    float ytmod = mod(yt, heightDim) / heightDim;
    
    if (mod(yt / heightDim, 2.0) < 1.0) {
      float xfrom = (1. - ytmod) / 2.;
      float xto = ytmod / 2. + .5;
      
      if (xtmod > xfrom && xtmod < xto) {
        xt = xtmod;
        yt = ytmod * (to - from) + from;
      } else {
        xt = xtmod - .5;
        yt = 1. - (ytmod * (to - from) + from);
      }
    } else {
      float xfrom = ytmod / 2.;
      float xto = (1. - ytmod) * .5 + .5;
      
      if (xtmod > xfrom && xtmod < xto) {
        xt = xtmod;
        yt = (1. - ytmod) * (to - from) + from;
      } else {
        xt = xtmod - .5;
        yt = 1. - ((1. - ytmod) * (to - from) + from);
      }
    }
  } else if (group == GROUP_PMM) {
    float heightDim = PATTERN_DIM - 2. * offset;
    float from = offset / PATTERN_DIM;
    float to = 1. - offset / PATTERN_DIM;

    if (mod(xt / PATTERN_DIM, 2.0) < 1.0) {
      xt = mod(xt, PATTERN_DIM) / PATTERN_DIM;
    } else {
      xt = 1. - mod(xt, PATTERN_DIM) / PATTERN_DIM;
    }
    
    if (mod(yt / heightDim, 2.0) < 1.0) {
      yt = mod(yt, heightDim) / heightDim * (to - from) + from;
    } else {
      yt = (1. - mod(yt, heightDim) / heightDim) * (to - from) + from;
    }
  } else if (group == GROUP_PMG) {
    float heightDim = PATTERN_DIM - 2. * offset;
    float from = offset / PATTERN_DIM;
    float to = 1. - offset / PATTERN_DIM;

    if (mod(xt / PATTERN_DIM, 2.0) < 1.0) {
      if (mod(yt / heightDim, 2.0) < 1.0) {
        xt = mod(xt, PATTERN_DIM) / PATTERN_DIM;
        yt = mod(yt, heightDim) / heightDim * (to - from) + from;
      } else {
        xt = mod(xt, PATTERN_DIM) / PATTERN_DIM;
        yt = (1. - mod(yt, heightDim) / heightDim) * (to - from) + from;
      }
    } else {
      if (mod(yt / heightDim, 2.0) < 1.0) {
        xt = 1. - mod(xt, PATTERN_DIM) / PATTERN_DIM;
        yt = (1. - mod(yt, heightDim) / heightDim) * (to - from) + from;
      } else {
        xt = 1. - mod(xt, PATTERN_DIM) / PATTERN_DIM;
        yt = mod(yt, heightDim) / heightDim * (to - from) + from;
      }
    }
  } else if (group == GROUP_PGG) {
    float heightDim = PATTERN_DIM - 2. * offset;
    float from = offset / PATTERN_DIM;
    float to = 1. - offset / PATTERN_DIM;
    float xtmod = mod(xt, PATTERN_DIM) / PATTERN_DIM;
    float ytmod = mod(yt, heightDim) / heightDim;
    
    if (mod(yt / heightDim, 2.0) < 1.0) {
      float xfrom = (1. - ytmod) / 2.;
      float xto = ytmod / 2. + .5;
      
      if (xtmod > xfrom && xtmod < xto) {
        xt = xtmod;
        yt = ytmod * (to - from) + from;
      } else {
        xt = xtmod - .5;
        yt = 1. - (ytmod * (to - from) + from);
      }
    } else {
      float xfrom = ytmod / 2.;
      float xto = (1. - ytmod) * .5 + .5;
      
      if (xtmod > xfrom && xtmod < xto) {
        xt =  1. - xtmod;
        yt = (1. - ytmod) * (to - from) + from;
      } else {
        xt = (1. - xtmod) - .5;
        yt = ytmod * (to - from) + from;
      }
    }
    
  } else if (group == GROUP_CMM) {
    float heightDim = PATTERN_DIM - 2. * offset;
    float from = offset / PATTERN_DIM;
    float to = 1. - offset / PATTERN_DIM;
    float xtmod = mod(xt, PATTERN_DIM) / PATTERN_DIM;
    float ytmod = mod(yt, heightDim) / heightDim;

    if (mod(xt / PATTERN_DIM, 2.0) < 1.0) {
      if (mod(yt / heightDim, 2.0) < 1.0) {
        if (ytmod > 1. - xtmod) {
          xt = xtmod;
          yt = ytmod * (to - from) + from;
        } else {
          xt = 1. - xtmod;
          yt = (1. - ytmod) * (to - from) + from;
        }
      } else {
        if (ytmod < xtmod) {
          xt = xtmod;
          yt = (1. - ytmod) * (to - from) + from;
        } else {
          xt = 1. - xtmod;
          yt = ytmod * (to - from) + from;
        }
      }
    } else {
      if (mod(yt / heightDim, 2.0) < 1.0) {
        if (ytmod > xtmod) {
          xt = 1. - xtmod;
          yt = ytmod * (to - from) + from;
        } else {
          xt = xtmod;
          yt = (1. - ytmod) * (to - from) + from;
        }
      } else {
        if (ytmod < 1. - xtmod) {
          xt = 1. - xtmod;
          yt = (1. - ytmod) * (to - from) + from;
        } else {
          xt = xtmod;
          yt = ytmod * (to - from) + from;
        }
      }
    }
    
  } else if (group == GROUP_P4) {
    float xtmod = mod(xt, PATTERN_DIM) / PATTERN_DIM;
    float ytmod = mod(yt, PATTERN_DIM) / PATTERN_DIM;
    
    if (mod(xt / PATTERN_DIM, 2.0) < 1.0) {
      if (mod(yt / PATTERN_DIM, 2.0) < 1.0) {
        xt = xtmod;
        yt = ytmod;
      } else {
        xt = 1. - ytmod;
        yt = xtmod;
      }
    } else {
      if (mod(yt / PATTERN_DIM, 2.0) < 1.0) {
        xt = ytmod;
        yt = 1. - xtmod;
      } else {
        xt = 1. - xtmod;
        yt = 1. - ytmod;
      }
    }
  } else if (group == GROUP_P4M) {
    float from = offset / PATTERN_DIM;
    float to = 1. - offset / PATTERN_DIM;
    float xtmod = mod(xt, PATTERN_DIM) / PATTERN_DIM;
    float ytmod = mod(yt, PATTERN_DIM) / PATTERN_DIM;

    if (mod(xt / PATTERN_DIM, 2.0) < 1.0) {
      if (mod(yt / PATTERN_DIM, 2.0) < 1.0) {
        if (xtmod > ytmod) {
          xt = xtmod;
          yt = ytmod;
        } else {
          xt = ytmod;
          yt = xtmod;
        }
      } else {
        if (ytmod < 1. - xtmod) {
          xt = 1. - ytmod;
          yt = xtmod;
        } else {
          xt = xtmod;
          yt = 1. - ytmod;
        }
      }
    } else {
      if (mod(yt / PATTERN_DIM, 2.0) < 1.0) {
        if (ytmod < 1. - xtmod) {
          xt = 1. - xtmod;
          yt = ytmod;
        } else {
          xt = ytmod;
          yt = 1. - xtmod;
        }
      } else {
        if (xtmod > ytmod) {
          xt = 1. - ytmod;
          yt = 1. - xtmod;
        } else {
          xt = 1. - xtmod;
          yt = 1. - ytmod;
        }
      }
    }
    
  } else if (group == GROUP_P4G) {
    float from = offset / PATTERN_DIM;
    float to = 1. - offset / PATTERN_DIM;
    float xtmod = mod(xt, PATTERN_DIM) / PATTERN_DIM;
    float ytmod = mod(yt, PATTERN_DIM) / PATTERN_DIM;

    if (mod(xt / PATTERN_DIM, 2.0) < 1.0) {
      if (mod(yt / PATTERN_DIM, 2.0) < 1.0) {
        if (ytmod > 1. - xtmod) {
          xt = xtmod;
          yt = ytmod;
        } else {
          xt = 1. - ytmod;
          yt = 1. - xtmod;
        }
      } else {
        if (xtmod > ytmod) {
          xt = 1. - ytmod;
          yt = xtmod;
        } else {
          xt = 1. - xtmod;
          yt = ytmod;
        }
      }
    } else {
      if (mod(yt / PATTERN_DIM, 2.0) < 1.0) {
        if (xtmod > ytmod) {
          xt = xtmod;
          yt = 1. - ytmod;
        } else {
          xt = ytmod;
          yt = 1. - xtmod;
        }
      } else {
        if (ytmod > 1. - xtmod) {
          xt = ytmod;
          yt = xtmod;
        } else {
          xt = 1. - xtmod;
          yt = 1. - ytmod;
        }
      }
    }

  } else if (group == GROUP_P3) {
    float cosFactor = cos(PI / 6.);
    float sinFactor = sin(PI / 6.);
    float tanFactor = tan(PI / 6.);
    
    float cos2Factor = cos(PI / 3.);
    float sin2Factor = sin(PI / 3.);
    float tan2Factor = tan(PI / 3.);
    
    float cos3Factor = cos(2. * PI / 3.);
    float sin3Factor = sin(2. * PI / 3.);
    float tan3Factor = tan(2. * PI / 3.);
    
    float cos4Factor = cos(4. * PI / 3.);
    float sin4Factor = sin(4. * PI / 3.);
    
    float widthDim = PATTERN_DIM * cosFactor * 2. / 3.;
    float offsetDim = (1. - cosFactor * 2. / 3.) / 2.;
    float from = offsetDim;
    float to = 1. - offsetDim;
    float xtmod = mod(xt, widthDim) / widthDim;
    float ytmod = mod(yt, PATTERN_DIM) / PATTERN_DIM;

    float offsetWidth = mod(xt / widthDim, 3.0);

    if (/*offsetWidth < 1.*/ true) {
      /* if (ytmod < tanFactor * xtmod * widthDim / PATTERN_DIM) {*/
      if( true) {
        xt =  cos3Factor * (xtmod + offsetDim) * (to - from) + from - sin3Factor * (ytmod + 1. / 3.);
        yt =  sin3Factor * (xtmod + offsetDim) * (to - from) + from + cos3Factor * (ytmod + 1. / 3.) - 1. / 3.;
      } else if (ytmod < tan2Factor * xtmod * widthDim / PATTERN_DIM) {
        /* xt =  cos4Factor * xtmod * (to - from) + from - sin4Factor * (ytmod + 1. / 3.);*/
        /* yt =  sin4Factor * xtmod * (to - from) + from + cos4Factor * (ytmod + 1. / 3.);*/
      }
    } else if (offsetWidth < 2.) {
      if (ytmod < (-tanFactor * xtmod) * widthDim / PATTERN_DIM + .3333333) {
        /* xt =  cos4Factor * (xtmod + offsetDim) * (to - from) + from - sin4Factor * (ytmod - 1. / 3.);*/
        /* yt =  sin4Factor * (xtmod + offsetDim) * (to - from) + from + cos4Factor * (ytmod - 1. / 3.) + 1. / 3.;*/
      } else if (xtmod < -sinFactor * ytmod + 1.) {
        /* xt = xtmod * (to - from) + from;*/
        /* yt = ytmod;*/
      } else {
        /* xt = xtmod *  cos2Factor * (to - from) + from;*/
        /* yt = ytmod * -sin2Factor;*/
      }
    } else {
      if (xt < sin2Factor * yt && xt > sinFactor * yt + .6666666) {
        /* xt = xtmod * cos2Factor * (to - from) + from;*/
        /* yt = ytmod * sin2Factor;*/
      } else if (true) {

      }
    }
    
  } else {
    
    xt = mod(xt, PATTERN_DIM) / PATTERN_DIM;
    yt = mod(yt, PATTERN_DIM) / PATTERN_DIM;

  }
  
  vec4 color = texture2D(sampler1, vec2(xt, yt));

  //add a radial blend
  vec4 colorFrom = color;
  vec4 colorTo = color * radialFactor;
  vec2 uv = gl_FragCoord.xy / resolution.xy;
  float ratio = resolution.y / resolution.x;
  vec2 center = vec2(.5, .5);

  gl_FragColor = colorFrom + (colorTo - colorFrom) * distance(uv, center) / distance(vec2(1., 1.), center);
}
