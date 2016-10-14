require(reshape)
require(ggplot2)
require(Cairo)

ts1=c(2.02, 2.33, 2.99, 6.85, 9.20, 8.80, 7.50, 6.00, 5.85, 3.85, 4.85, 3.85, 2.22, 1.45, 1.34)
ts2=c(0.50, 1.29, 2.58, 3.83, 3.25, 4.25, 3.83, 5.63, 6.44, 6.25, 8.75, 8.83, 3.25, 0.75, 0.72)
dist(rbind(ts1,ts2), method = "euclidean")

df=data.frame(x=c(0:14),ts1,ts2)
dd=melt(df, id.var=c("x"))
p0=ggplot(dd, aes(x,value,color=variable))+theme_bw()+geom_line(size=1)+geom_point(size=3)+
  ggtitle("Raw data")+scale_x_continuous("time")+scale_color_discrete("Data:")
p0

png(filename = "../sax_data.png",
    width = 600, height = 350, units = "px", pointsize = 12,
    bg = "white",  type ="cairo-png")
print(p0)
dev.off()

# 2.0
znorm <- function(ts){
  ts.mean <- mean(ts)
  ts.dev <- sd(ts)
  (ts - ts.mean)/ts.dev
}

ts1_znorm=znorm(ts1)
ts2_znorm=znorm(ts2)

df=data.frame(x=c(0:14),ts1_znorm,ts2_znorm)
dd=melt(df, id.var=c("x"))
p0=ggplot(dd, aes(x,value,color=variable))+theme_bw()+geom_line(size=1)+geom_point(size=3)+
  ggtitle(expression(paste(atop(italic("Z")),atop("-normalized data"))))+
  scale_x_continuous("time")+scale_color_discrete("Data:") + geom_hline(yintercept=0,linetype="longdash", color="brown2")
p0

png(filename = "../sax_znorm.png",
    width = 600, height = 350, units = "px", pointsize = 12,
    bg = "white",  type ="cairo-png")
print(p0)
dev.off()

# 3.0
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


dd=melt(df, id.var=c("x"))
p1=ggplot(dd, aes(x,value,color=variable))+theme_bw()+geom_line()+geom_point()+
  ggtitle("Time series and their PAA to 9 points")
p1

paa_size=9
s1_paa = paa(ts1_znorm,paa_size)
s2_paa = paa(ts2_znorm,paa_size)
slength=14/paa_size
segments1=data.frame(x=seq(0,slength*(paa_size-1),b=slength), 
                    xend=seq(slength,slength*(paa_size),b=slength), 
                    y=s1_paa, yend=s1_paa, variable=rep("ts1_paa_9",paa_size))
segments2=data.frame(x=seq(0,slength*(paa_size-1),b=slength), 
                     xend=seq(slength,slength*(paa_size),b=slength), 
                     y=s2_paa, yend=s2_paa, variable=rep("ts2_paa_9",paa_size))
p2=p1+geom_segment(data=segments1, aes(x=x,y=y,xend=xend,yend=yend), size=2)+
  geom_segment(data=segments2, aes(x=x,y=y,xend=xend,yend=yend), size=2)+
  geom_point(data=segments1, aes(x=x+slength/2,y=y), size=5) +
  geom_point(data=segments2, aes(x=x+slength/2,y=y), size=5) +  
  geom_vline(data=segments, aes(xintercept=x), linetype="longdash", color="brown2")+
  geom_vline(xintercept=14, linetype="longdash", color="brown2")
p2

png(filename = "../sax_paa1.png",
    width = 600, height = 350, units = "px", pointsize = 12,
    bg = "white",  type ="cairo-png")
print(p2)
dev.off()

p3=ggplot(data=segments1, aes(x=x,y=y,xend=xend,yend=yend))+geom_segment(size=2,color="cyan2")+
  geom_segment(data=segments2, aes(x=x,y=y,xend=xend,yend=yend), size=2, color="brown")+
  geom_point(data=segments1, aes(x=x+slength/2,y=y), size=5, color="cyan2") +
  geom_point(data=segments2, aes(x=x+slength/2,y=y), size=5, color="brown") +
  geom_vline(data=segments1, aes(xintercept=x), linetype="longdash", color="brown2")+
  geom_vline(xintercept=14, linetype="longdash", color="brown2") + theme_bw() + 
  geom_hline(data=data.frame(x=c(-0.67,0.0,0.67)), aes(yintercept=x), linetype="longdash", color="blue2") +
  ggtitle("An example of the SAX distance computation")

dff=data.frame(xx=c(unlist(segments1[3,1:2]),unlist(segments2[3,c(2,1)])),
               yy=c(unlist(segments1[3,3:4]),unlist(segments2[3,3:4])) )
p3=p3 + geom_polygon(inherit.aes = FALSE, data=dff, aes(x=xx,y=yy), fill="orange")

dff=data.frame(xx=c(unlist(segments1[7,1:2]),unlist(segments2[7,c(2,1)])),
               yy=c(unlist(segments1[7,3:4]),unlist(segments2[7,3:4])) )
p3=p3 + geom_polygon(inherit.aes = FALSE, data=dff, aes(x=xx,y=yy), fill="orange")

for(i in c(1,2,4,5,6,8,9)){
dff=data.frame(xx=c(unlist(segments1[i,1:2]),unlist(segments2[i,1:2])),
               yy=c(unlist(segments1[i,3:4]),unlist(segments2[i,3:4])) )
p3=p3 + geom_polygon(inherit.aes = FALSE, data=dff, aes(x=xx,y=yy), fill="cadetblue")
}
p3=p3 + geom_text(aes(label="a",x=-0.5,y=-1),size=14,color="brown3") + 
  geom_text(aes(label="b",x=-0.5,y=-0.3),size=14,color="brown3") + 
  geom_text(aes(label="c",x=-0.5,y=0.3),size=14,color="brown3") + 
  geom_text(aes(label="d",x=-0.5,y=1),size=14,color="brown3")

png(filename = "../sax_distances.png",
    width = 600, height = 350, units = "px", pointsize = 12,
    bg = "white",  type ="cairo-png")
print(p3)
dev.off()
