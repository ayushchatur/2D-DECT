#!/bin/bash
#SBATCH --job-name=ddnet
#SBATCH --partition=p100_normal_q
#SBATCH --time=16:00:00
#SBATCH -A HPCBIGDATA2
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --gres=gpu:2

### change 5-digit MASTER_PORT as you wish, slurm will raise Error if duplicated with others
### change WORLD_SIZE as gpus/node * num_nodes


export MASTER_PORT=8888
#export WORLD_SIZE=4

### get the first node name as master address - customized for vgg slurm
### e.g. master(gnodee[2-5],gnoded1) == gnodee2
echo "NODELIST="${SLURM_NODELIST}

if [ ${SLURM_NODELIST:7:1} == "," ]; then 
    echo "MASTER_ADDR="${SLURM_NODELIST:0:7}
    export MASTER_ADDR=${SLURM_NODELIST:0:7}
elif [ ${SLURM_NODELIST:3:1} == "[" ]; then
    echo "MASTER_ADDR="${SLURM_NODELIST:0:3}${SLURM_NODELIST:4:3}
    export MASTER_ADDR=${SLURM_NODELIST:0:3}${SLURM_NODELIST:4:3}
else
    echo "MASTER_ADDR="${SLURM_NODELIST}
    export MASTER_ADDR=${SLURM_NODELIST}
fi 

mkdir ./loss
mkdir ./reconstructed_images
mkdir ./reconstructed_images/val
mkdir ./reconstructed_images/test
mkdir ./visualize
mkdir ./visualize/val/
mkdir ./visualize/val/mapped/
mkdir ./visualize/val/diff_target_out/
mkdir ./visualize/val/diff_target_in/
mkdir ./visualize/val/input/
mkdir ./visualize/val/target/
mkdir ./visualize/test/
mkdir ./visualize/test/mapped/
mkdir ./visualize/test/diff_target_out/
mkdir ./visualize/test/diff_target_in/
mkdir ./visualize/test/input/
mkdir ./visualize/test/target/



module load  apps  site/infer/easybuild/setup
module load PyTorch/1.7.1-fosscuda-2020b
cd ~
source scpr/bin/activate
cd -
#cd /projects/synergy_lab/garvit*/sc*/batch_16*

### the command to run
srun python train_main2_jy.py -n 1 -g 2 --batch 1 --epochs 50

#sbatch --nodes=1 --ntasks-per-node=8 --gres=gpu:1 --partition=normal_q -t 1600:00 ./batch_job.sh
