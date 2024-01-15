i=1
while [ $i -le 5 ]
do
lon_in=`sed "${i}q;d" lat_lon_f1.dat | cut -d ' ' -f1`
lat_in=`sed "${i}q;d" lat_lon_f1.dat | cut -d ' ' -f2`
#echo $lon_in $lat_in
DIR_IN=`echo "INPUT_"$lon_in"_"$lat_in"_1960_64"` ###!! <=== USER INPUT 1
FILE_OUT=`echo "OUT_"$lon_in"_"$lat_in"_1960_64.txt"`  ###!! <=== USER INPUT 1
LOG_OUT=`echo "LOG_"$lon_in"_"$lat_in"_1960_64.txt"`   ###!! <=== USER INPUT 1
ERR_OUT=`echo "ERR_"$lon_in"_"$lat_in"_1960_64.txt"`   ###!! <=== USER INPUT 1
echo "-------------------------------------------------------------------------"
echo "******************FORCING PARAMETRS EXTRACTION START********************"
echo "-------------------------------------------------------------------------"
mkdir OUTPUT
ferret -nojnl << EOF

let lon_in = $lon_in               
let lat_in = $lat_in               
let clm_init = 1                   
set reg/t=01-jan-1960:31-dec-1964  !! <=== USER IDIR_INPUT 2

sp mkdir $DIR_IN

sp rm -rf INPUT/
sp mkdir INPUT/

sp echo $lon_in > "./INPUT/details_argo11.txt"
sp echo $lat_in >> "./INPUT/details_argo11.txt"
use /home/DESK/bhavani/TESTING_2023/FISH_NEMURO/FORCING_DATA/T2M_1960_2020.nc
use /home/DESK/bhavani/TESTING_2023/FISH_NEMURO/FORCING_DATA/TP_1960_2020.nc
use /home/DESK/bhavani/TESTING_2023/FISH_NEMURO/FORCING_DATA/SFX_1960_2020.nc
use /home/DESK/bhavani/TESTING_2023/FISH_NEMURO/FORCING_DATA/SPE_1960_2020.nc
use /home/DESK/bhavani/TESTING_2023/FISH_NEMURO/FORCING_DATA/U10_1960_2020.nc
use /home/DESK/bhavani/TESTING_2023/FISH_NEMURO/FORCING_DATA/V10_1960_2020.nc
use /home/DESK/bhavani/TESTING_2023/FISH_NEMURO/FORCING_DATA/SSS_1960_2020_25KM_3DAY_FILL.nc
use /home/DESK/bhavani/TESTING_2023/FISH_NEMURO/FORCING_DATA/WVEL/WVEL_1960_1989_3DAY_250m_FILL.nc !!USER INPUT 3 CHECK THE FILE

use /home/DESK/bhavani/TESTING_2023/NEMURO_RUN/DATA_ARCHIVE/salt_5m_cli_fill.nc
use /home/DESK/bhavani/TESTING_2023/NEMURO_RUN/DATA_ARCHIVE/temp_5m_cli_fill.nc
use /home/DESK/bhavani/TESTING_2023/NEMURO_RUN/DATA_ARCHIVE/woa18_nitrate_01_12_MON_250m_fill.nc
use /home/DESK/bhavani/TESTING_2023/NEMURO_RUN/DATA_ARCHIVE/woa18_silicate_01_12_MON_250m_fill.nc

save/clobber/x=${lon_in}/y=${lat_in}/format=(f22.10)/nohead/k=1/file="./INPUT/air_temp_data_for_argo11.txt" t2m[d=1] - 273.15  ! 6-hourly data
save/clobber/x=${lon_in}/y=${lat_in}/format=(f22.10)/nohead/k=1/file="./INPUT/ppt_data_for_argo11.txt" tp[d=2]/(60*60) ! for 12 hourly total precipitation to rain in m/s 
save/clobber/x=${lon_in}/y=${lat_in}/format=(f22.10)/nohead/k=1/file="./INPUT/sfx_in_data_for_argo11.txt" ssr[d=3]/(60*60) ! for hourly total j/m2 to j/s/m2. 12-hourly data.
save/clobber/x=${lon_in}/y=${lat_in}/format=(f22.10)/nohead/k=1/file="./INPUT/specific_hum_data_for_argo11.txt" q[d=4] ! 6-hourly data in kg/kg
save/clobber/x=${lon_in}/y=${lat_in}/format=(f22.10)/nohead/k=1/file="./INPUT/uwnd_data_for_argo11.txt" u10[d=5] ! 6-hourly data in m/s
save/clobber/x=${lon_in}/y=${lat_in}/format=(f22.10)/nohead/k=1/file="./INPUT/vwnd_data_for_argo11.txt" v10[d=6] ! 6-hourly data in m/s
save/clobber/x=${lon_in}/y=${lat_in}/format=(f22.10)/nohead/k=1/file="./INPUT/salinity_clim_data_for_argo11.txt" sss[d=7] ! 3 day data in p.s.u.
save/clobber/x=${lon_in}/y=${lat_in}/k=1:51/file=wvel_extracted_argo11.nc wvel[d=8] ! vertical velcoity in m/s

cancel reg
save/clobber/x=${lon_in}/y=${lat_in}/format=(f22.10)/nohead/k=1:51/file="./INPUT/salt_in_data_for_argo11.txt" salt[d=9] ! salinity initial condition in p.s.u. (51 levels)
save/clobber/x=${lon_in}/y=${lat_in}/format=(f22.10)/nohead/k=1:51/file="./INPUT/temp_in_data_for_argo11.txt" temp[d=10] ! temperature initial condition in oC (51 levels)

save/clobber/x=${lon_in}/y=${lat_in}/format=(f22.10)/nohead/k=1:51/file="./INPUT/NO3_in_data_for_argo11.DAT"/l=1 nitrate[d=11] ! no3 initial condition in microM/l (51 levels)
save/clobber/x=${lon_in}/y=${lat_in}/format=(f22.10)/nohead/k=1:51/file="./INPUT/SIOH4_in_data_for_argo11.DAT"/l=1 silicat[d=12] ! sioh4 initial condition in microM/l (51 levels)

save/clobber/x=${lon_in}/y=${lat_in}/format=(f22.10)/nohead/k=1:51/file="./INPUT/no3_clim_extract_jan_argo11.txt"/l=1 nitrate[d=11] ! no3 initial condition in microM/l (51 levels)
save/clobber/x=${lon_in}/y=${lat_in}/format=(f22.10)/nohead/k=1:51/file="./INPUT/no3_clim_extract_feb_argo11.txt"/l=2 nitrate[d=11] ! no3 initial condition in microM/l (51 levels)
save/clobber/x=${lon_in}/y=${lat_in}/format=(f22.10)/nohead/k=1:51/file="./INPUT/no3_clim_extract_mar_argo11.txt"/l=3 nitrate[d=11] ! no3 initial condition in microM/l (51 levels)
save/clobber/x=${lon_in}/y=${lat_in}/format=(f22.10)/nohead/k=1:51/file="./INPUT/no3_clim_extract_apr_argo11.txt"/l=4 nitrate[d=11] ! no3 initial condition in microM/l (51 levels)
save/clobber/x=${lon_in}/y=${lat_in}/format=(f22.10)/nohead/k=1:51/file="./INPUT/no3_clim_extract_may_argo11.txt"/l=5 nitrate[d=11] ! no3 initial condition in microM/l (51 levels)
save/clobber/x=${lon_in}/y=${lat_in}/format=(f22.10)/nohead/k=1:51/file="./INPUT/no3_clim_extract_jun_argo11.txt"/l=6 nitrate[d=11] ! no3 initial condition in microM/l (51 levels)
save/clobber/x=${lon_in}/y=${lat_in}/format=(f22.10)/nohead/k=1:51/file="./INPUT/no3_clim_extract_jul_argo11.txt"/l=7 nitrate[d=11] ! no3 initial condition in microM/l (51 levels)
save/clobber/x=${lon_in}/y=${lat_in}/format=(f22.10)/nohead/k=1:51/file="./INPUT/no3_clim_extract_aug_argo11.txt"/l=8 nitrate[d=11] ! no3 initial condition in microM/l (51 levels)
save/clobber/x=${lon_in}/y=${lat_in}/format=(f22.10)/nohead/k=1:51/file="./INPUT/no3_clim_extract_sep_argo11.txt"/l=9 nitrate[d=11] ! no3 initial condition in microM/l (51 levels)
save/clobber/x=${lon_in}/y=${lat_in}/format=(f22.10)/nohead/k=1:51/file="./INPUT/no3_clim_extract_oct_argo11.txt"/l=10 nitrate[d=11] ! no3 initial condition in microM/l (51 levels)
save/clobber/x=${lon_in}/y=${lat_in}/format=(f22.10)/nohead/k=1:51/file="./INPUT/no3_clim_extract_nov_argo11.txt"/l=11 nitrate[d=11] ! no3 initial condition in microM/l (51 levels)
save/clobber/x=${lon_in}/y=${lat_in}/format=(f22.10)/nohead/k=1:51/file="./INPUT/no3_clim_extract_dec_argo11.txt"/l=12 nitrate[d=11] ! no3 initial condition in microM/l (51 levels)

save/clobber/x=${lon_in}/y=${lat_in}/format=(f22.10)/nohead/k=1:51/file="./INPUT/sioh4_clim_extract_jan_argo11.txt"/l=1 silicat[d=12] ! no3 initial condition in microM/l (51 levels) 
save/clobber/x=${lon_in}/y=${lat_in}/format=(f22.10)/nohead/k=1:51/file="./INPUT/sioh4_clim_extract_feb_argo11.txt"/l=2 silicat[d=12] ! no3 initial condition in microM/l (51 levels) 
save/clobber/x=${lon_in}/y=${lat_in}/format=(f22.10)/nohead/k=1:51/file="./INPUT/sioh4_clim_extract_mar_argo11.txt"/l=3 silicat[d=12] ! no3 initial condition in microM/l (51 levels) 
save/clobber/x=${lon_in}/y=${lat_in}/format=(f22.10)/nohead/k=1:51/file="./INPUT/sioh4_clim_extract_apr_argo11.txt"/l=4 silicat[d=12] ! no3 initial condition in microM/l (51 levels) 
save/clobber/x=${lon_in}/y=${lat_in}/format=(f22.10)/nohead/k=1:51/file="./INPUT/sioh4_clim_extract_may_argo11.txt"/l=5 silicat[d=12] ! no3 initial condition in microM/l (51 levels) 
save/clobber/x=${lon_in}/y=${lat_in}/format=(f22.10)/nohead/k=1:51/file="./INPUT/sioh4_clim_extract_jun_argo11.txt"/l=6 silicat[d=12] ! no3 initial condition in microM/l (51 levels) 
save/clobber/x=${lon_in}/y=${lat_in}/format=(f22.10)/nohead/k=1:51/file="./INPUT/sioh4_clim_extract_jul_argo11.txt"/l=7 silicat[d=12] ! no3 initial condition in microM/l (51 levels) 
save/clobber/x=${lon_in}/y=${lat_in}/format=(f22.10)/nohead/k=1:51/file="./INPUT/sioh4_clim_extract_aug_argo11.txt"/l=8 silicat[d=12] ! no3 initial condition in microM/l (51 levels) 
save/clobber/x=${lon_in}/y=${lat_in}/format=(f22.10)/nohead/k=1:51/file="./INPUT/sioh4_clim_extract_sep_argo11.txt"/l=9 silicat[d=12] ! no3 initial condition in microM/l (51 levels) 
save/clobber/x=${lon_in}/y=${lat_in}/format=(f22.10)/nohead/k=1:51/file="./INPUT/sioh4_clim_extract_oct_argo11.txt"/l=10 silicat[d=12] ! no3 initial condition in microM/l (51 levels)
save/clobber/x=${lon_in}/y=${lat_in}/format=(f22.10)/nohead/k=1:51/file="./INPUT/sioh4_clim_extract_nov_argo11.txt"/l=11 silicat[d=12] ! no3 initial condition in microM/l (51 levels)
save/clobber/x=${lon_in}/y=${lat_in}/format=(f22.10)/nohead/k=1:51/file="./INPUT/sioh4_clim_extract_dec_argo11.txt"/l=12 silicat[d=12] ! no3 initial condition in microM/l (51 levels)

sp rm "./INPUT/wvel_extracted_argo11.bin"
sp ./run_fort
sp ./read
q
EOF
echo "-------------------------------------------------------------------------"
echo "*****************FORCING PARAMETRS EXTRACTION END*********************"
echo "-------------------------------------------------------------------------"
argo_no='11'
#======================================================================
echo "-------------------------------------------------------------------------"
echo "*****************MODEL RUN START*********************"
echo "-------------------------------------------------------------------------"
sed  -e  "s/details_argo/details_argo$argo_no/g" main_ver7_argo.F  > main01.F
sed  -e  "s/air_temp_data/air_temp_data_for_argo$argo_no/g"  main01.F > main0.F
sed  -e  "s/uwnd_data/uwnd_data_for_argo$argo_no/g" main0.F > main1.F
sed  -e  "s/vwnd_data/vwnd_data_for_argo$argo_no/g" main1.F > main2.F
sed  -e  "s/sfx_in_data/sfx_in_data_for_argo$argo_no/g" main2.F > main3.F
sed  -e  "s/ppt_data/ppt_data_for_argo$argo_no/g" main3.F > main4.F
sed  -e  "s/wvel_data/wvel_extracted_argo$argo_no/g" main4.F > main5.F #Fhis file is actualy not needed for calculations.
sed  -e  "s/specific_hum_data/specific_hum_data_for_argo$argo_no/g" main5.F > main6.F
sed  -e  "s/salinity_clim_data/salinity_clim_data_for_argo$argo_no/g" main6.F > main7.F # in which location  salinity_clim extracted???
sed  -e  "s/temp_in_data/temp_in_data_for_argo$argo_no/g" main7.F > main8.F # in which location  salinity_clim extracted???
sed  -e  "s/salt_in_data/salt_in_data_for_argo$argo_no/g" main8.F > main9.F # in which location  salinity_clim extracted???
sed  -e  "s/NO3_in_data/NO3_in_data_for_argo$argo_no/g" main9.F > main10.F # in which location  salinity_clim extracted???
sed  -e  "s/SIOH4_in_data/SIOH4_in_data_for_argo$argo_no/g" main10.F > main11.F # in which location  salinity_clim extracted???
sed  -e  "s/temp_clim_data/temp_clim_data_for_argo$argo_no/g" main11.F > main12.F # in which location  salinity_clim extracted???
sed  -e  "s/argo/argo$argo_no/g" relaxation_nutrients_ver2.F > relax.F
#======================================================================

echo "ifort -Dsnap_tracer -I/opt/cray/pe/netcdf/4.4.1.1.3/INTEL/16.0/include -g -traceback -extend-source 132 -O3 -L/opt/cray/pe/netcdf/4.4.1.1.3/INTEL/16.0/lib main12.F nemuro_3D_ver2.F moto_v7_ver4.F implicit.F snaps.F stresstc.F  Irradiance_with_depth.F daily_average.F relax.F -mkl -lnetcdff"
ifort -Dsnap_tracer -I/opt/cray/pe/netcdf/4.4.1.1.3/INTEL/16.0/include -g -traceback -extend-source 132 -O3 -L/opt/cray/pe/netcdf/4.4.1.1.3/INTEL/16.0/lib main12.F nemuro_3D_ver2.F moto_v7_ver4.F implicit.F snaps.F stresstc.F  Irradiance_with_depth.F daily_average.F relax.F -mkl -lnetcdff

echo "-------------------------------------------------------------------------"
echo "****************** MODEL IS RUNNING at $lon_in $lat_in ******************"
echo "-------------------------------------------------------------------------"
echo "                                                                         "
./a.out > $FILE_OUT 2>$ERR_OUT
mv -v $FILE_OUT OUTPUT/
mv -v INPUT/* $DIR_IN
echo "                                                                         "
echo "-------------------------------------------------------------------------"
echo "****************** MODEL RUN END ************************"
echo "-------------------------------------------------------------------------"
rm -v a.out main?.F
######################################################################
i=$(( $i + 1 ))
done
