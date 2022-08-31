
function define_uv_coverage, uv_n, sqrt_uv_min=sqrt_uv_min, sqrt_uv_max=sqrt_uv_max, n=n

if uv_n mod 2 eq 0 then message, "uv_n must be odd!"

default, sqrt_uv_min, sqrt(0.01)
default, sqrt_uv_max, 1.
default, n, 2

;;******************* Define (u,v) values

;; Square root spacing in both u and v
sqrt_uv = findgen((uv_n-1)/2)/((uv_n-1)/2-1) * (sqrt_uv_max - sqrt_uv_min) + sqrt_uv_min

;; Positive u and v coordinates
uv_pos = sqrt_uv^n

;; Array of u and v values
uv_tmp = [-reverse(uv_pos),0,uv_pos]

u = cmreplicate(uv_tmp,uv_n)
v = transpose(u)

u = reform(u, float(uv_n)*float(uv_n))
v = reform(v, float(uv_n)*float(uv_n))

return, {u:u, v:v}

end