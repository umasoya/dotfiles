# bashrc
# Yasuto Souma

# Environment variables
export DOT_DIR="${HOME}/dotfiles"
export BDOT_DIR="${HOME}/dotfiles/.bash"

# Load ${BDOT_DIR}/*.bash
for i in ${BDOT_DIR}/*.bash;do
  source ${i}
done
