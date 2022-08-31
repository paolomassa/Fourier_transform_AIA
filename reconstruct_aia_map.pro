
;;****** Set the path of the folder containing the code

folder = "" 

add_path, folder + "aux_code"
data_folder = folder + "data/"

;;****** AIA maps path

fits_files = data_folder + ["aia.lev1_euv_12s.2014-10-26T124805Z.304.image.fits", $
                            "aia.lev1_euv_12s.2014-10-26T124817Z.304.image.fits", $
                            "aia.lev1_euv_12s.2014-10-26T124817Z.131.image.fits"]

;;****** Load AIA map

; Select index fits file to analyze
idx = 0
this_fits_file = fits_files[0]

; Extract wavelength from filename - used for plots

idx_init  = strpos(this_fits_file, "Z") + 2
idx_final = strpos(this_fits_file, "image") - 1
wav = STRMID(this_fits_file, idx_init, idx_final-idx_init)

; Load AIA map
this_fits_file = fits_files[idx]
fits2map, this_fits_file, aia_map

; Plot AIA map
chsize=1.5

aia_lct,wav=float(wav),/load
window,0
cleanplot
plot_map,aia_map,title="AIA " + wav, /log
stop

;;****** Define (u,v) points used for the Fourier transform

uv_n = 21
uv = define_uv_coverage(uv_n)

; Plot (u,v) points
window, 1
cleanplot
plot, uv.u,uv.v,title="(u,v) points",xrange=[-1.1,1.1],yrange=[-1.1,1.1],psym=4,/xst,/yst,/iso,charsize=chsize

stop

;;****** Compute visibilities

im = aia_map.data
imsize = size(im, /dim)
pixel  = [aia_map.dx, aia_map.dy] ;; Pixel size (arcsec)

F = vis_map2vis_matrix(uv.u, uv.v, imsize, pixel)
obsvis = F # im[*]

; Plot visibility amplitude map
amp_vis = abs(obsvis)

vis_amp_map = reform(amp_vis, uv_n, uv_n)
vis_amp_map[(uv_n-1)/2,(uv_n-1)/2]=0

window,2
cleanplot
plot_image, vis_amp_map, /log

stop

;;****** MEM_GE reconstruction

vis = replicate(stx_visibility(),  n_elements(obsvis))
vis.u = uv.u
vis.v = uv.v
vis.obsvis = obsvis
vis.sigamp = 1.

total_flux = max(abs(obsvis))

mem_ge_map = mem_ge(vis, total_flux, percent_lambda = percent_lambda, $
                    imsize=imsize, pixel = pixel, /makemap)
  
window,3
cleanplot
plot_map, mem_ge_map, title="MEM_GE", /log


end