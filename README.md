# Real-time Video Dehazing based on Spatio-temporal MRF
Bolun Cai, Xiangmin Xu, Dacheng Tao

### Introduction
Video dehazing has a wide range of real-time applications, but the challenges mainly come from spatio-temporal coherence and computational efficiency. In this paper, a spatio-temporal optimization framework for real-time video dehazing is proposed, which reduces blocking and flickering artifacts and achieves high-quality enhanced results. We build a Markov Random Field (MRF) with an Intensity Value Prior (IVP) to handle spatial consistency and temporal coherence. By maximizing the MRF likelihood function, the proposed framework estimates the haze concentration and preserves the information optimally. Moreover, to facilitate real-time applications, integral image technique is approximated to reduce the main computational burden. Experimental results demonstrate that the proposed framework is effectively to remove haze and flickering artifacts, and sufficiently fast for real-time applications.
![ST-MRF](https://caibolun.github.io/st-mrf/framework.jpg)


If you use these codes in your research, please cite:

	@inproceedings{cai2016stmrf,
	  author={Cai, Bolun and Xu, Xiangmin and Tao, Dacheng},
	  title={Real-Time Video Dehazing Based on Spatio-Temporal MRF},
	  booktitle={Pacific Rim Conference on Multimedia},
	  pages={315--325},
	  year={2016},
	  organization={Springer}
	}
### Usage
#### 1. Tutorial

You can run the demo with 
```
run('demo.m')
```

In addition, inspired by [*Fast Guided Filter*](https://arxiv.org/abs/1505.00996), a faster ST-MRF (`fast_stMRF.m`) is provided with 2 times faster than the original ST-MRF.
```
run('fast_demo.m')
```

#### 2. Test on your video

If you want to use your video for dehazing, a video-to-image tools is provided:
```
video2image(<VIDEO_FILENAME>)
```

#### 3. Recompile

We pre-compile MEX files (`convConst.mexw64`, `convConst.mexw64`, `MinPooling.mexw64`) for Win-X64. If the codes are run on the other platform, please recompile the MEX files and type: 
```
mex -setup
mex convConst.cpp
mex imResampleMex.cpp
mex MinPooling.cpp
```

### Demo
http://player.youku.com/player.php/sid/XMTU1NTAwOTAwMA==/v.swf