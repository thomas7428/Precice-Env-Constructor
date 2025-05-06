#!/usr/bin/env csh

# Script intented to be run after the installation of the package
mkdir ~/src/

# Modify MPI comportement for memory constraints
setenv UCX_TLS shm,self

# Build-related settings
setenv WM_NCOMPPROCS `nproc`
setenv CPLUS_INCLUDE_PATH "$CONDA_PREFIX/include"
setenv LIBRARY_PATH "$CONDA_PREFIX/lib"
setenv LD_LIBRARY_PATH "$CONDA_PREFIX/lib"
setenv MPI_ARCH_PATH "$CONDA_PREFIX"
setenv MPI_ROOT "$MPI_ARCH_PATH"
setenv WM_CC  "$CONDA_PREFIX/bin/cc"
setenv WM_CXX "$CONDA_PREFIX/bin/c++"
setenv WM_CFLAGS   ""
setenv WM_CXXFLAGS ""

#Installing dolfinx adapter 
#cd ~/src/
#git clone https://github.com/precice/fenicsx-adapter.git
#cd fenicsx-adapter
#pip3 install --user .
# We need to downgrade mpi4py to a pre 4.0 version
#conda install -c conda-forge mpi4py=3.1.6
# Testing the installation
#cd ~/src/fenicsx-adapter/tutorials/partitioned-heat-conduction/dirichlet-fenicsx
#bash ./run.sh

#Installing dolfin (https://fenics.readthedocs.io/en/latest/installation.html)
cd ~/src/
setenv PYBIND11_VERSION "2.2.3"
wget -nc --quiet https://github.com/pybind/pybind11/archive/v${PYBIND11_VERSION}.tar.gz
tar -xf v${PYBIND11_VERSION}.tar.gz && cd pybind11-${PYBIND11_VERSION}
mkdir build && cd build && cmake -DPYBIND11_TEST=off .. && make install
pip3 install fenics-ffc --upgrade
setenv FENICS_VERSION "2019.1.0"
cd ~/src/
git clone --branch=$FENICS_VERSION https://bitbucket.org/fenics-project/dolfin
git clone --branch=$FENICS_VERSION https://bitbucket.org/fenics-project/mshr
mkdir dolfin/build && cd dolfin/build && cmake .. -DCMAKE_INSTALL_PREFIX=$CONDA_PREFIX && make install && cd ../..
mkdir mshr/build   && cd mshr/build   && cmake .. -DCMAKE_INSTALL_PREFIX=$CONDA_PREFIX && make install && cd ../..
cd dolfin/python && pip3 install . --prefix=$CONDA_PREFIX && cd ../..
cd mshr/python   && pip3 install . --prefix=$CONDA_PREFIX && cd ../..

# Installing dolfin adapter
cd ~/src/
wget https://github.com/precice/fenics-adapter/archive/refs/tags/v2.2.0.tar.gz
tar -xzf v2.2.0.tar.gz 
cd fenics-adapter-2.2.0
pip install . --prefix=$CONDA_PREFIX 
# Test the installation

# Installing the mshr module
#cd ~/src/
#git clone https://bitbucket.org/fenics-project/mshr.git
#cd mshr
#mkdir build
#cd build
#cmake -DCMAKE_INSTALL_PREFIX=$CONDA_PREFIX -DCMAKE_BUILD_TYPE=Release -DCMAKE_POLICY_VERSION_MINIMUM=3.5 ..
#make -j
#make install
#python3 -c "import fenicsprecice"

#Installing OpenFOAM
bash orterun --version

mkdir ~/OpenFOAM
cd ~/Precice-Env-Constructor/Constructor/
tar xvjf openfoam-OpenFOAM-v2412.tar.bz2 -C ~/src/
tar xvjf ThirdParty-common-v2412.tar.bz2 -C ~/src/
mv ~/src/openfoam-OpenFOAM-v2412 ~/OpenFOAM/OpenFOAM-v2412
mv ~/src/ThirdParty-common-v2412 ~/OpenFOAM/ThirdParty-v2412

# Wait a button to check if the installation was successful
echo "Press any key to continue..."
set key = $<  # Attendre que l'utilisateur appuie sur une touche

cd ~/OpenFOAM/OpenFOAM-v2412
# We need to specify the location
sed -i 's|^set projectDir=.*|set projectDir="$HOME/OpenFOAM/OpenFOAM-$WM_PROJECT_VERSION"|' $HOME/OpenFOAM/OpenFOAM-v2412/etc/cshrc
#We also need to modify setenv WM_MPLIB SYSTEMOPENMPI to setenv WM_MPLIB MPICH
sed -i 's|^setenv WM_MPLIB SYSTEMOPENMPI|setenv WM_MPLIB SYSTEMMPI|' $HOME/OpenFOAM/OpenFOAM-v2412/etc/cshrc

# Create the prefs.sys-mpi file
cat > "$HOME/OpenFOAM/OpenFOAM-v2412/etc/config.csh/prefs.sys-mpi" <<EOF

# Point to MPI installed via conda (e.g. mpich or openmpi)
setenv MPI_ARCH_PATH "$CONDA_PREFIX"
setenv MPI_ROOT "$MPI_ARCH_PATH"
setenv FOAM_MPI "mpich-4.2.2"

# Flags for compilation
setenv MPI_ARCH_FLAGS "-DOMPI_SKIP_MPICXX"
setenv MPI_ARCH_INC "-isystem $MPI_ROOT/include"

# Flags for linking with mpi and zlib
setenv MPI_ARCH_LIBS "-L$MPI_ROOT/lib -lmpi -lz"
EOF

#Create the prefs.cshrc file
cat > "$HOME/OpenFOAM/OpenFOAM-v2412/etc/prefs.csh" <<EOF
# prefs.csh - Configure SYSTEMMPI to use the conda installation
setenv WM_MPLIB SYSTEMMPI
setenv CONDA_PREFIX ~/miniconda3/envs/precice_env
setenv MPI_ARCH_PATH \$CONDA_PREFIX
setenv PATH "\$MPI_ARCH_PATH/bin:\$PATH"
setenv LD_LIBRARY_PATH "\$MPI_ARCH_PATH/lib:\$LD_LIBRARY_PATH"
setenv CPPFLAGS "-I\$MPI_ARCH_PATH/include"
setenv CXXFLAGS "-I\$MPI_ARCH_PATH/include"
setenv LDFLAGS "-L\$MPI_ARCH_PATH/lib"

EOF

# Wait a button to check if the installation was successful
echo "Press any key to continue..."
set key = $<  # Attendre que l'utilisateur appuie sur une touche

source $HOME/OpenFOAM/OpenFOAM-v2412/etc/prefs.csh
source $HOME/OpenFOAM/OpenFOAM-v2412/etc/cshrc
echo "source $HOME/OpenFOAM/OpenFOAM-v2412/etc/cshrc" >> ~/.cshrc
bash foamSystemCheck
bash foam
bash ./Allwmake -l -j -q -k #-j to use all cores ; -k to keep going and compile everything it can ; -q to not show the compilation ; -l to show the compilation log
bash foamInstallationTest
bash foamTestTutorial -full incompressible/simpleFoam/pitzDaily

# Wait a button to check if the installation was successful
echo "Press any key to continue..."
set key = $<  # Attendre que l'utilisateur appuie sur une touche


# Installing OpenFOAM adapter
cd ~/src/
git clone https://github.com/precice/openfoam-adapter.git
cd openfoam-adapter
# Verify that it is the master branch and v1.3.1 tag
git checkout master
git checkout v1.3.1
bash ./Allwmake -j


#Pause to check if the installation was successful
echo "Press any key to continue..."
set key = $<  # Attendre que l'utilisateur appuie sur une touche


#Installing Calculix adapter
cd ~/Precice-Env-Constructor/Constructor/
# Extract the source code from Constructor into ~/
tar xvjf ccx_2.20.src.tar.bz2 -C ~/
cd ~/src/
wget https://github.com/precice/calculix-adapter/archive/refs/tags/v2.20.1.tar.gz
tar -xzf v2.20.1.tar.gz
cd calculix-adapter-2.20.1

# We need to adapt to the conda installation
sed -i 's|^SPOOLES_INCLUDE.*|SPOOLES_INCLUDE   = -I$(CONDA_PREFIX)/include/spooles|' Makefile
sed -i 's|^SPOOLES_LIBS.*|SPOOLES_LIBS      = -L$(CONDA_PREFIX)/lib -l:spoolesMT.a -l:spooles.a|' Makefile
sed -i 's|^ARPACK_INCLUDE.*|ARPACK_INCLUDE    = -I$(CONDA_PREFIX)/include/arpack|' Makefile
sed -i 's|^ARPACK_LIBS.*|ARPACK_LIBS       = -L$(CONDA_PREFIX)/lib -larpack -llapack -lblas|' Makefile
sed -i 's|^YAML_INCLUDE.*|YAML_INCLUDE      = -I$(CONDA_PREFIX)/include/yaml-cpp|' Makefile
sed -i 's|^YAML_LIBS.*|YAML_LIBS         = -L$(CONDA_PREFIX)/lib -lyaml-cpp|' Makefile
# We need to adapt the compiler flags because of the recent GCC we use (>= 10)
sed -i '/^FFLAGS =/s|$| -fallow-argument-mismatch|' Makefile
make clean
make -j

# Put the compiled bin inside the environment
cp ~/src/calculix-adapter-2.20.1/bin/ccx_preCICE $CONDA_PREFIX/bin/
# Test it via the version command
ccx_preCICE --version

#Install the turorials
cd ~/src/
git clone https://github.com/precice/tutorials.git

#Create the virtua python environment for Dolfin
cd ~/src/
conda create -n precice_python python=3.13
setenv PYTHONPATH "$CONDA_PREFIX/lib/python3.13/site-packages"
conda activate precice_python

# Define the user's home directory (replace ~ with /etc for a global .cshrc)
set USER_HOME = $HOME

# Create the .cshrc file in the user's home directory
cat > "$USER_HOME/.cshrc" <<EOF
# .cshrc - Custom configuration for tcsh

#Message to indicate that the source began
echo "Sourcing .cshrc file..."

# Initialize Conda
if ( -f \$HOME/miniconda3/etc/profile.d/conda.csh ) then
    source \$HOME/miniconda3/etc/profile.d/conda.csh
endif

# Activate the desired Conda environment (precice_env)
conda init
conda activate precice_env

# Modify MPI comportement for memory constraints
setenv UCX_TLS shm,self

# Build-related settings
setenv WM_NCOMPPROCS `nproc`
setenv CPLUS_INCLUDE_PATH "$CONDA_PREFIX/include"
setenv LIBRARY_PATH "$CONDA_PREFIX/lib"
setenv LD_LIBRARY_PATH "$CONDA_PREFIX/lib"

# Set the environment for MPI
setenv WM_MPLIB USERMPI
setenv MPI_ARCH_PATH \$CONDA_PREFIX
setenv PATH "\$MPI_ARCH_PATH/bin:\$PATH"
setenv LD_LIBRARY_PATH "\$MPI_ARCH_PATH/lib:\$LD_LIBRARY_PATH"
setenv OMP_NUM_THREADS `nproc`

# Add OpenFOAM to the PATH environment variable
setenv PATH \$HOME/OpenFOAM/OpenFOAM-v2412/platforms/linux64Gcc/bin:\$PATH

# Initialize OpenFOAM after the environment setup
source \$HOME/OpenFOAM/OpenFOAM-v2412/etc/cshrc

# Optional: create an alias to quickly source OpenFOAM
alias foam "source \$HOME/OpenFOAM/OpenFOAM-v2412/etc/cshrc"

# Message to indicate that the .cshrc file has been sourced
echo "Sourcing completed !"
EOF

echo "✅ The .cshrc file has been created in: $USER_HOME/.cshrc"

#Inform about the .cshrc or .bashrc files to complete
echo "⚠️ Please remember to verify or add the following lines to your ~/.cshrc file: (specify what you want for nproc if you do not want to use all of your cores)"
echo "   setenv UCX_TLS shm,self"
echo "   setenv WM_NCOMPPROCS `nproc`"
echo "   setenv OMP_NUM_THREADS `nproc`" 
echo "   setenv CPLUS_INCLUDE_PATH '$CONDA_PREFIX/include\'"
echo "   setenv LIBRARY_PATH '$CONDA_PREFIX/lib\'"
echo "   source ~/OpenFOAM/OpenFOAM-v2412/etc/cshrc"
echo "   source ~/miniconda3/etc/profile.d/conda.csh"
echo "   setenv PYTHONPATH '$CONDA_PREFIX/lib/python3.13/site-packages'"

# Inform about the tutorials
echo "⚠️ The tutorials are located in ~/src/tutorials"

# End message    
echo "✅ All done!"