#!/bin/bash


mkdir -p /output/assignments

mkdir -p /output/lectures/notes
mkdir -p /output/lectures/slides


# build syllabus
# ==============

cd /source
ssh-agent bash -c 'ssh-add $GIT_PRIVATE_KEYFILE; git clone $SYLLABUS_PROJECT'
cd $SYLLABUS_DIR
make install
# NOTE: make install copies the syllabus PDF to /output

# build assignments
# =================

cd /source
ssh-agent bash -c 'ssh-add $GIT_PRIVATE_KEYFILE; git clone $ASSIGNMENTS_PROJECT'
cd $ASSIGNMENTS_DIR
make install
# NOTE: make install copies all assignment PDFs to /output/assignments


# build lectures
# ==============

cd /source
ssh-agent bash -c 'ssh-add $GIT_PRIVATE_KEYFILE; git clone $LECTURES_PROJECT'
cd $LECTURES_DIR
make -B install
# NOTE: make install copies all lecture PDFs to /output/lectures



