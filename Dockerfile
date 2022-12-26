FROM fedora-minimal as templates-getter

WORKDIR /template
RUN mkdir -p /template

# Install assignment and lecture tempates
# =======================================

RUN microdnf install -y git \
    && microdnf clean all

# pull assignments template
RUN git clone https://github.com/dmflickinger/RBE550-assignment-template.git
 
# pull lectures template
RUN git clone https://github.com/dmflickinger/RBE550-lecture-template.git
 


FROM fedora-minimal


WORKDIR /source

# Install packages for building LaTeX documents
# =============================================



# TODO: pull package list from file instead
RUN microdnf install -y texlive-adjustbox \
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
                #    which \
                #    ffmpeg \
                   git \
    && microdnf clean all



RUN mkdir -p /source \
    && mkdir -p /output \
    && mkdir -p /bib \
    && mkdir -p /usr/share/texlive/texmf-local/tex/latex/RBEassignment/fig \
    && mkdir -p /usr/share/texlive/texmf-local/tex/latex/RBElecture/fig \
    && mkdir -p /usr/local/share/LaTeX_templates/RBE550_lecture/fig/


# Pull tempate files from intermediate container
# ----------------------------------------------

COPY --from=templates-getter /template/RBE550-assignment-template/template/RBEassignment.cls /usr/share/texlive/texmf-local/tex/latex/RBEassignment/
COPY --from=templates-getter /template/RBE550-assignment-template/template/fig/*.png /usr/share/texlive/texmf-local/tex/latex/RBEassignment/fig/



COPY --from=templates-getter /template/RBE550-lecture-template/fig/placeholder.pdf /usr/local/share/LaTeX_templates/RBE550_lecture/fig/
COPY --from=templates-getter /template/RBE550-lecture-template/template/RBElecture.cls /usr/share/texlive/texmf-local/tex/latex/RBElecture/
COPY --from=templates-getter /template/RBE550-lecture-template/template/fig/*.png /usr/share/texlive/texmf-local/tex/latex/RBElecture/fig/


# Register the RBE classes with texlive
RUN tlmgr conf texmf TEXMFHOME /usr/share/texlive/texmf-local \
    && mktexlsr /usr/share/texlive/texmf-local



# TODO: pull RBE resources to /bib

# TODO: pull syllabus to /source
# TODO: pull assignments to /source
# TODO: pull lectures to /source





# COPY scripts/build.sh /usr/local/bin/


# TODO: configure entrypoint to kick off building everything
# ENTRYPOINT [ "/usr/local/bin/build.sh" ]


#VOLUME [ "/source" "/output" "/bib"]

