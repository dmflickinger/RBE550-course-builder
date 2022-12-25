FROM fedora

WORKDIR /source

# Install packages (mainly texlive)
# =================================


RUN dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
		   https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm \
    && dnf clean all


RUN dnf install -y texlive-adjustbox \
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
                   python3-pygments \
                   python3-pygments-style-solarized \
                   which \
                   ffmpeg \
                   git \
    && dnf clean all


RUN mkdir -p /source \
    && mkdir -p /output \
    && mkdir -p /bib

# TODO: put template stuff in multistage build container

# pull assignments template
RUN git clone https://github.com/dmflickinger/RBE550-assignment-template.git

# install assignments template
COPY assignmenttemplate/template/RBEassignment.cls /usr/share/texlive/texmf-local/tex/latex/RBEassignment/
COPY assignmenttemplate/template/fig/*.png /usr/share/texlive/texmf-local/tex/latex/RBEassignment/fig/



# pull lectures template
RUN git clone https://github.com/dmflickinger/RBE550-lecture-template.git

# install lectures template
COPY lecturetemplate/fig/*.pdf /usr/local/share/LaTeX_templates/RBE550_lecture/fig/

COPY lecturetemplate/template/RBElecture.cls /usr/share/texlive/texmf-local/tex/latex/RBElecture/
COPY lecturetemplate/template/fig/*.png /usr/share/texlive/texmf-local/tex/latex/RBElecture/fig/

COPY lecturetemplate/scripts/build.sh /usr/local/bin/
COPY lecturetemplate/scripts/encodeVideo.sh /usr/local/bin/




# Register the RBE classes with texlive
RUN tlmgr conf texmf TEXMFHOME /usr/share/texlive/texmf-local \
    && mktexlsr /usr/share/texlive/texmf-local


# TODO: pull syllabus to /source
# TODO: pull assignments to /source
# TODO: pull lectures to /source





# COPY scripts/build.sh /usr/local/bin/


# TODO: configure entrypoint to kick off building everything
# ENTRYPOINT [ "/usr/local/bin/build.sh" ]


#VOLUME [ "/source" "/output" "/bib"]

