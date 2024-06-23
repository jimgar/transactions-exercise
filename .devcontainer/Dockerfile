# Using the Rocker base R image for convenience's sake - it even comes with 
# radian! Also specifying the linux/amd64 image, which is required so that 
# Ubuntu binaries get picked up from Posit Package Manager. Hash taken from:
# https://github.com/rocker-org/devcontainer-images/pkgs/container/devcontainer%2Fr-ver
FROM ghcr.io/rocker-org/devcontainer/r-ver:4.4@sha256:e99cfe63efd5d79f44146d8be8206019fd7a7230116aa6488097ee660d6aa5dc

# options(warn=2) will make the build error out if package doesn't install
RUN R -e "options(warn = 2); install.packages('pak')"
# Using {pak} to install R packages: it resolves Ubuntu system dependencies AND
# the R dependency tree!
RUN R -e "options(warn = 2); pak::pak( \ 
    c( \ 
    'dbplyr', \ 
    'dplyr', \
    'duckdb' \ 
    ))"

# Latest stable release. See 'Specific Quarto version' at
# https://docs.posit.co/resources/install-quarto.html#download-and-install-quarto-using-.deb-file
ARG QUARTO_VERSION="1.4.551"
RUN curl -o quarto-linux-amd64.deb -L https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.deb
RUN apt install /quarto-linux-amd64.deb && \
    rm /quarto-linux-amd64.deb