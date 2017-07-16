.onAttach <- function(...)
{
    msg <- paste("This is hdrcde", utils::packageVersion("hdrcde"))
    base::packageStartupMessage(msg)
}
