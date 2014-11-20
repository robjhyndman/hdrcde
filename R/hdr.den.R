# Function to plot density with hdrs shown
# Modifications suggested by Freuer Dennis

hdr.den <- function(x, prob=c(50,95,99), den, h=hdrbw(BoxCox(x,lambda),mean(prob)), 
    lambda=1, xlab=NULL, ylab="Density", ylim=NULL, plot.lines=TRUE, col=2:8, ...)
{
  if(missing(den))
    den <- tdensity(x,bw=h,lambda=lambda)
  else if(missing(x))
    x <- sample(den$x, 500, replace=TRUE, prob=den$y)

  maxden <- max(den$y)
  stepy <- maxden*0.02
  if(is.null(ylim))
    ylim <- c((1-length(prob))*stepy, maxden)

  plot(den, type="n", xlab=xlab, ylab=ylab, ylim=ylim, xaxt="n", yaxt="n", ...)
  rangex <- range(x, na.rm=TRUE)
  minx <- rangex[1]
  maxx <- rangex[2]
  rangex <- maxx-minx
  polygon(c(minx-0.5*rangex, maxx+0.5*rangex, maxx+0.5*rangex, minx-0.5*rangex),
    c(0,0,rep(-length(prob)*stepy*2,2)),col="gray",border=FALSE)
  #abline(h=0, col="gray")
  lines(den$x,den$y)
  box()
  axis(1)
  axis(2, at=pretty(c(0,maxden)))

  hd <- hdr(x=x, prob=prob, den=den, h=h)
  nregions <- nrow(hd$hdr)

  leng <- dim(hd$hdr)[[2]]
  
  # Colours for HDRs
  if(nregions > 8) 
  {
    repcol <- ceiling(length(prob)/8)
    col <- rep(col, repcol)
  }

  if(plot.lines)
  {
    for(i in 1:nregions)
    {
      abline(h=hd$falpha[i], col=col[i], lty=2)
      for(j in 1:length(hd$hdr[i,]))
        lines(rep(hd$hdr[i,j],2), c(stepy*(i-nregions),hd$falpha[i]),col=col[i], lty=2)
    }
  }
  for(i in 1:nregions)
    add.hdr(hd$hdr[i,], (i-nregions-0.5)*stepy, stepy, col=col[i], horiz=TRUE)
  return(hd)
}
