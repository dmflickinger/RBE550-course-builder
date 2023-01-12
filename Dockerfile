FROM fedora as templates-getter

WORKDIR /template
RUN mkdir -p /template

# Install assignment and lecture tempates
# =======================================

RUN dnf install -y git git-lfs \
    && dnf clean all

# pull assignments template
RUN git clone https://github.com/dmflickinger/RBE550-assignment-template.git
 
# pull lectures template
RUN git clone https://github.com/dmflickinger/RBE550-lecture-template.git

# pull resources
RUN git clone https://github.com/dmflickinger/RBE550resources.git



FROM fedora


WORKDIR /source


COPY scripts/build_course.sh /usr/local/bin/

RUN mkdir -p /source \
    && mkdir -p /bib \
    && mkdir -p /usr/share/texlive/texmf-local/tex/latex/RBEassignment/fig \
    && mkdir -p /usr/share/texlive/texmf-local/tex/latex/RBElecture/fig \
    && mkdir -p /usr/local/share/LaTeX_templates/RBE550_lecture/fig/


# Pull template files from intermediate container
# ----------------------------------------------

COPY --from=templates-getter /template/RBE550-assignment-template/template/RBEassignment.cls /usr/share/texlive/texmf-local/tex/latex/RBEassignment/
COPY --from=templates-getter /template/RBE550-assignment-template/template/fig/*.png /usr/share/texlive/texmf-local/tex/latex/RBEassignment/fig/



COPY --from=templates-getter /template/RBE550-lecture-template/fig/placeholder.pdf /usr/local/share/LaTeX_templates/RBE550_lecture/fig/
COPY --from=templates-getter /template/RBE550-lecture-template/template/RBElecture.cls /usr/share/texlive/texmf-local/tex/latex/RBElecture/
COPY --from=templates-getter /template/RBE550-lecture-template/template/fig/*.png /usr/share/texlive/texmf-local/tex/latex/RBElecture/fig/
COPY --from=templates-getter /template/RBE550-lecture-template/scripts/encodeVideo.sh /usr/local/bin/

COPY --from=templates-getter /template/RBE550resources/*.bib /bib/


# Install packages for building LaTeX documents
# =============================================


RUN dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
		   https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm \
    && dnf clean all


RUN dnf install --nodocs -y \
                   texlive-adjustbox \
                   texlive-background \
                   texlive-bibtex \
                   texlive-biblatex \
                   texlive-biblatex-ieee \
                   texlive-ccfonts \
                   texlive-changepage \
                   texlive-chktex \
                   texlive-comfortaa \
                   texlive-datetime \
                   texlive-datetime2 \
                   texlive-dot2texi \
                   texlive-draftwatermark \
                   texlive-droid \
                   texlive-electrum \
                   texlive-epigraph \
                   texlive-euro-ce \
                   texlive-fontawesome \
                   texlive-fontawesome5 \
                   texlive-collection-fontsrecommended \
                   texlive-fourier \
                   texlive-IEEEtran \
                   texlive-ifmtarg \
                   texlive-inconsolata \
                   texlive-kpfonts \
                   texlive-lastpage \
                   texlive-listing \
                   texlive-makecmds \
                   texlive-mathdots \
                   texlive-mathspec \
                   texlive-mdframed \
                   texlive-metafont \
                   texlive-minted \
                   texlive-mnsymbol \
                   texlive-multirow \
                   texlive-pdfcrop \
                   texlive-pgfgantt \
                   texlive-pgfopts \
                   texlive-pygmentex \
                   texlive-roboto \
                   texlive-sectsty \
                   texlive-siunitx \
                   texlive-smartdiagram \
                   texlive-sourcecodepro \
                   texlive-subfigmat \
                   texlive-svg \
                   texlive-tcolorbox \
                   texlive-titlesec \
                   texlive-titling \
                   texlive-tocloft \
                   texlive-todonotes \
                   texlive-wrapfig \
                   texlive-xifthen \
                   texlive-xtab \
                   texlive-xetex \
                   texlive-beamer \
                   texlive-nextpage \
                   texlive-fancybox \
                   texlive-algorithm2e \
                   texlive-progressbar \
                   graphviz \
                   make \
                   ossobuffo-jura-fonts \
                   poppler-utils \
                   python3-pygments \
                   python3-pygments-style-solarized \
                   ffmpeg \
                   git \
                   git-lfs \
    && dnf clean all




# Register the RBE classes with texlive
RUN tlmgr conf texmf TEXMFHOME /usr/share/texlive/texmf-local \
    && mktexlsr /usr/share/texlive/texmf-local




# configure entrypoint to kick off building everything
ENTRYPOINT [ "/usr/local/bin/build_course.sh" ]


#VOLUME [ "/source" "/output" "/bib"]

# NOTE: for example, use podman to run this container:
# podman run --rm -v ~/.ssh:/root/.ssh -v ./output:/output --env-file=env.txt rbe550-course
