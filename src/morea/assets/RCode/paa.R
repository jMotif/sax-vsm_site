require(reshape)
require(ggplot2)
require(Cairo)

series1 <- c(2.02, 2.33, 2.99, 6.85, 9.20, 8.80, 7.50, 6.00, 5.85, 3.85, 4.85, 3.85, 2.22, 1.45, 1.34)

df=data.frame(x=c(0:14),series1)
dd=melt(df, id.var=c("x"))
p0=ggplot(dd, aes(x,value,color=variable))+theme_bw()+geom_line(size=1)+geom_point(size=3)+
  ggtitle("Raw data")+scale_x_continuous("time")+scale_color_discrete("Data:")
p0

png(filename = "../paa_raw.png",
    width = 600, height = 350, units = "px", pointsize = 12,
    bg = "white",  type ="cairo-png")
print(p0)
dev.off()

# PAA transform function
#
#
paa <- function(ts, paa_size){
  len = length(ts)
  if (len == paa_size) {
    ts
  }
  else {
    if (len %% paa_size == 0) {
      colMeans(matrix(ts, nrow=len %/% paa_size, byrow=F))
    }
    else {
      res = rep.int(0, paa_size)
      for (i in c(0:(len * paa_size - 1))) {
        idx = i %/% len + 1# the spot
        pos = i %/% paa_size + 1 # the col spot
        res[idx] = res[idx] + ts[pos]
      }
      for (i in c(1:paa_size)) {
        res[i] = res[i] / len
      }
      res
    }
  }
}

#
# ###################
#
df=data.frame(x=c(0:14),series1)
dd=melt(df, id.var=c("x"))
p1=ggplot(dd, aes(x,value,color=variable))+theme_bw()+geom_line()+geom_point()+
  ggtitle("Time series #1 and its PAA to 7 points")
p1

paa_size=7
s1_paa = paa(series1,paa_size)
as.numeric(format(s1_paa, digits=3))
slength=14/paa_size
segments=data.frame(x=seq(0,slength*(paa_size-1),b=slength), 
                    xend=seq(slength,slength*(paa_size),b=slength), 
                    y=s1_paa, yend=s1_paa, variable=rep("PAA 7",paa_size))
p2=p1+geom_segment(data=segments, aes(x=x,y=y,xend=xend,yend=yend), size=2)+
  geom_point(data=segments, aes(x=x+slength/2,y=y), size=5) +
  geom_vline(data=segments, aes(xintercept=x), linetype="longdash", color="brown2")+
  geom_vline(xintercept=14, linetype="longdash", color="brown2")
p2

png(filename = "../paa7.png",
    width = 600, height = 350, units = "px", pointsize = 12,
    bg = "white",  type ="cairo-png")
print(p2)
dev.off()

#
# ###################
#
df=data.frame(x=c(0:14),series1)
dd=melt(df, id.var=c("x"))
p1=ggplot(dd, aes(x,value,color=variable))+theme_bw()+geom_line()+geom_point()+
  ggtitle("Time series #1 and its PAA to 9 points")
p1

paa_size=9
s1_paa = paa(series1,paa_size)
as.numeric(format(s1_paa, digits=3))
slength=14/paa_size
segments=data.frame(x=seq(0,slength*(paa_size-1),b=slength), 
                    xend=seq(slength,slength*(paa_size),b=slength), 
                    y=s1_paa, yend=s1_paa, variable=rep("PAA 9",paa_size))
p2=p1+geom_segment(data=segments, aes(x=x,y=y,xend=xend,yend=yend), size=2)+
  geom_point(data=segments, aes(x=x+slength/2,y=y), size=5) +
  geom_vline(data=segments, aes(xintercept=x), linetype="longdash", color="brown2")+
  geom_vline(xintercept=14, linetype="longdash", color="brown2")
p2

png(filename = "../paa9.png",
    width = 600, height = 350, units = "px", pointsize = 12,
    bg = "white",  type ="cairo-png")
print(p2)
dev.off()
