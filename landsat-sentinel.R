library(raster)
library(maptools)
library(maps)
library(rgdal)
mydir = "D:/Other/Remote_sensing_data/"
setwd(mydir)
'
#landsat data
img_red <- raster(paste0(mydir, "LC08_L1TP_127045_20170604_20170604_01_RT_B4.TIF"))
img_blue <- raster(paste0(mydir, "LC08_L1TP_127045_20170604_20170604_01_RT_B2.TIF"))
img_green <- raster(paste0(mydir, "LC08_L1TP_127045_20170604_20170604_01_RT_B3.TIF"))
img = stack(img_red, img_green,img_blue)
'
#setinel-2
#s2_red = readGDAL(paste0(mydir, "sentinel/B04.jp2"))
s2_red = raster(paste0(mydir, "sentinel/B04.tif"))
s2_blue = raster(paste0(mydir, "sentinel/B02.tif"))
s2_green = raster(paste0(mydir, "sentinel/B03.tif"))
s2 = stack(s2_red, s2_green, s2_blue)
#plotRGB(img, r = 1, g = 2, b = 3, scale = 65535, colNA = 'white', stretch='lin')
plotRGB(s2, r = 1, g = 2, b = 3, scale = 65535, colNA = 'white', stretch='lin')
# Night light
fn <- dir(paste0(mydir,"nightlight/",2013),pattern = "stable_lights.avg_vis.tif$", full.names = TRUE)
ntl = raster(fn)
#Crop night light
e = extent(s2)
p <- as(e, 'SpatialPolygons')  
crs(p) <- crs(s2)
p = spTransform(p, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))
ntl2 = crop(ntl, p, snap = "near")
alignExtent(extent(p), ntl2, snap='near')

#Plot full map
plotRGB(s2, r = 1, g = 2, b = 3, scale = 65535, colNA = 'white', stretch='lin')
plot(ntl2, col = grey(1:1000/1000), add=T, legend=F, alpha = 0.6)
# Plot custom zoomed-in
e = drawExtent()
plotRGB(s2, r = 1, g = 2, b = 3, scale = 65535, colNA = 'white', stretch='lin', ext = e)
plot(ntl2, col = grey(1:1000/1000), add=T, legend=F, alpha = 0.5, ext = e)



#Zoom in
e = drawExtent(show = TRUE)
plotRGB(s2, r = 1, g = 2, b = 3, scale = 65535, colNA = 'white', stretch='lin', ext = e)

#customized shapefile (ho guom)
shpfile = shapefile(paste0(mydir, "click2shp_out_point.shp"))
shpfile2 = spTransform(shpfile, CRS("+proj=utm +zone=48 +datum=WGS84"))
img_sub = crop(img, shpfile2)
#plotRGB(img_sub, r = 1, g = 2, b = 3, scale = 65535, colNA = 'white', stretch='lin')


#vietnam shapefile
mp <- shapefile(paste0(mydir,"VNM_adm_shp/VNM_adm1.shp"))
mp2 =  spTransform(mp, CRS("+proj=utm +zone=48 +datum=WGS84"))
img_sub = crop(img, mp2[23,])
r = mask(img_sub,mp2[23,])
plot(mp2[23,])
plot(r, add = T)

#plotRGB(img_sub, r = 1, g = 2, b = 3, scale = 65535, colNA = 'white', stretch='lin', band = 1)

"
grayscale_colors <- gray.colors(100,            # number of different color levels 
                                start = 0.0,    # how black (0) to go
                                end = 1.0,      # how white (1) to go
                                gamma = 2.2,    # correction between how a digital 
                                # camera sees the world and how human eyes see it
                                alpha = NULL)   #Null=colors are not transparentpar(mfrow = c(1,1))
"
  