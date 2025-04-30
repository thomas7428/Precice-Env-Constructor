# Script intented to be run after the installation of the package
mkdir ~/src/

# Activate the precice_env environment
source ~/miniconda3/etc/profile.d/conda.sh
conda activate precice_env
# Modify MPI comportement for memory constraints
grep -qxF 'setenv UCX_TLS shm,self' ~/.cshrc || echo 'setenv UCX_TLS shm,self' >> ~/.cshrc
# Add the cshrc file of OpenFOAM
grep -qxF 'source $CONDA_PREFIX/etc/cshrc' ~/.cshrc || echo 'source $CONDA_PREFIX/etc/cshrc' >> ~/.cshrc
# Reload the shell
source ~/.cshrc


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
cd ~/src/
git clone https://bitbucket.org/fenics-project/mshr.git
cd mshr
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=$CONDA_PREFIX -DCMAKE_BUILD_TYPE=Release -DCMAKE_POLICY_VERSION_MINIMUM=3.5 ..
make -j
make install
python3 -c "import fenicsprecice"

# Installing OpenFOAM adapter
cd ~/src/
git clone https://github.com/precice/openfoam-adapter.git
cd openfoam-adapter
# Verify that it is the master branch and v1.3.1 tag
git checkout master
git checkout v1.3.1


# Adapt for the conda installation
sed -i '/^EXE_INC.*/a \    -I$(CONDA_PREFIX)/include/OpenFOAM-2412/src/transportModels/interfaceProperties/lnInclude \\' Make/options && \
sed -i '/^EXE_INC.*/a \    -I$(CONDA_PREFIX)/include/OpenFOAM-2412/src/transportModels/interfaceProperties/ \\' Make/options && \
sed -i '/^EXE_INC.*/a \    -I$(CONDA_PREFIX)/include/OpenFOAM-2412/src/transportModels/twoPhaseMixture/lnInclude/ \\' Make/options && \
sed -i '/^EXE_INC.*/a \    -I$(CONDA_PREFIX)/include/OpenFOAM-2412/src/transportModels/incompressible/lnInclude/ \\' Make/options && \
sed -i '/^EXE_INC.*/a \    -I$(CONDA_PREFIX)/include/OpenFOAM-2412/src/transportModels/incompressibleTwoPhaseMixture/lnInclude/ \\' Make/options && \
sed -i '/^EXE_INC.*/a \    -I$(CONDA_PREFIX)/include/OpenFOAM-2412/src/transportModels/immiscibleIncompressibleTwoPhaseMixture/lnInclude/ \\' Make/options && \
sed -i '/^EXE_INC.*/a \    -I$(CONDA_PREFIX)/include/OpenFOAM-2412/src/transportModels/ \\' Make/options && \
sed -i '/^EXE_INC.*/a \    -I$(CONDA_PREFIX)/include/OpenFOAM-2412/src/transportModels/incompressible/transportModel \\' Make/options && \
sed -i '/^EXE_INC.*/a \    -I$(CONDA_PREFIX)/include/OpenFOAM-2412/src/TurbulenceModels/incompressible/lnInclude \\' Make/options && \
sed -i '/^EXE_INC.*/a \    -I$(CONDA_PREFIX)/include/OpenFOAM-2412/src/transportModels/compressible/lnInclude \\' Make/options && \
sed -i '/^EXE_INC.*/a \    -I$(CONDA_PREFIX)/include/OpenFOAM-2412/src/thermophysicalModels/basic/lnInclude \\' Make/options && \
sed -i '/^EXE_INC.*/a \    -I$(CONDA_PREFIX)/include/OpenFOAM-2412/src/TurbulenceModels/turbulenceModels/lnInclude \\' Make/options && \
sed -i '/^EXE_INC.*/a \    -I$(CONDA_PREFIX)/include/OpenFOAM-2412/src/TurbulenceModels/compressible/lnInclude \\' Make/options && \
sed -i '/^EXE_INC.*/a \    -I$(CONDA_PREFIX)/include/OpenFOAM-2412/src/meshTools/lnInclude \\' Make/options && \
sed -i '/^EXE_INC.*/a \    -I$(CONDA_PREFIX)/include/OpenFOAM-2412/src/finiteVolume/lnInclude \\' Make/options && \
sed -i '/^EXE_INC.*/a \    -I$(CONDA_PREFIX)/include/OpenFOAM-2412/src/OSspecific/POSIX/lnInclude \\' Make/options && \
sed -i '/^EXE_INC.*/a \    -I$(CONDA_PREFIX)/include/OpenFOAM-2412/src/OpenFOAM/lnInclude \\' Make/options

bash ./Allwmake -j

# Test the installation of openFOAM
cd ~/src/
wget https://github.com/precice/tutorials/archive/refs/tags/v202404.0.tar.gz
tar -xzf v202404.0.tar.gz
cd tutorials-202404.0/quickstart/fluid-openfoam
bash ./run.sh