const deployTicket = async ({ ethers, network, deployments }) => {
    const [deployer] = await ethers.getSigners();
    const name = "Viva Session Ticket";
    const symbol = "VST";

    const {address} = await deployments.deploy("NFTTicket", {
        from: deployer.address,
        args: [name, symbol],
        log: true
    });
};

module.exports = deployTicket;
