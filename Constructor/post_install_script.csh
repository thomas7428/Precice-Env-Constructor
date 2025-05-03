#!/usr/bin/env csh

# Script intented to be run after the installation of the package
mkdir ~/src/

# Verify it ~/.cshrc exists
if (! -e ~/.cshrc) then
    echo "Creating ~/.cshrc file..."
    touch ~/.cshrc

# Modify MPI comportement for memory constraints
setenv UCX_TLS shm,self
#Add the following lines to ~/.cshrc if it does not exist
echo "setenv UCX_TLS shm,self" >> ~/.cshrc

# Build-related settings
setenv WM_NCOMPPROCS `nproc`
setenv CPLUS_INCLUDE_PATH "$CONDA_PREFIX/include"
setenv LIBRARY_PATH "$CONDA_PREFIX/lib"

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

# Installing dolfin adapter
#cd ~/src/
#wget https://github.com/precice/fenics-adapter/archive/refs/tags/v2.2.0.tar.gz
#tar -xzf v2.2.0.tar.gz 
#cd fenics-adapter-2.2.0
#pip install --no-deps .
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
tar xvjf ThirdParty-common-main.tar.bz2 -C ~/src/
mv ~/src/openfoam-OpenFOAM-v2412 ~/OpenFOAM/OpenFOAM-v2412
mv ~/src/ThirdParty-common-main ~/OpenFOAM/ThirdParty-v2412

cd ~/OpenFOAM/OpenFOAM-v2412
# We need to specify the location
sed -i 's|^set projectDir=.*|set projectDir="$HOME/OpenFOAM/OpenFOAM-$WM_PROJECT_VERSION"|' $HOME/OpenFOAM/OpenFOAM-v2412/etc/cshrc
#We also need to specify that we use MPICH
sed -i 's|^set WM_MPLIB=.*|set WM_MPLIB=MPICH|' $HOME/OpenFOAM/OpenFOAM-v2412/etc/cshrc

source $HOME/OpenFOAM/OpenFOAM-v2412/etc/cshrc
echo "source $HOME/OpenFOAM/OpenFOAM-v2412/etc/cshrc" >> ~/.cshrc
bash foamSystemCheck
bash foam
bash ./Allwmake -l -j -q
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

#Inform about the .cshrc or .bashrc files to complete
echo "⚠️ Please remember to add the following lines to your ~/.cshrc file:"
echo "   setenv UCX_TLS shm,self"
echo "   setenv WM_NCOMPPROCS `nproc`"
echo "   setenv CPLUS_INCLUDE_PATH '$CONDA_PREFIX/include\'"
echo "   setenv LIBRARY_PATH '$CONDA_PREFIX/lib\'"
echo "   export PATH '$CONDA_PREFIX/bin:$PATH\'"
echo "   export LD_LIBRARY_PATH '$CONDA_PREFIX/lib:$LD_LIBRARY_PATH\'"
echo "   source ~/OpenFOAM/OpenFOAM-v2412/etc/cshrc"
echo "   source ~/OpenFOAM/OpenFOAM-v2412/etc/bashrc"
echo "   source ~/miniconda3/etc/profile.d/conda.csh"
echo "   setenv PYTHONPATH '$CONDA_PREFIX/lib/python3.13/site-packages'"

# Inform about the tutorials
echo "⚠️ The tutorials are located in ~/src/tutorials"

# End message    
echo "✅ All done!"