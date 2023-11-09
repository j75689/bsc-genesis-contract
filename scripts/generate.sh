#!/usr/bin/env bash

basedir=$(
    cd $(dirname $0)
    pwd
)

CHAIN_ID=714
INIT_CONSENSUS_STATE_BYTES="42696e616e63652d436861696e2d4e696c650000000000000000000000000000000000000000000229eca254b3859bffefaf85f4c95da9fbd26527766b784272789c30ec56b380b6eb96442aaab207bc59978ba3dd477690f5c5872334fc39e627723daa97e441e88ba4515150ec3182bc82593df36f8abb25a619187fcfab7e552b94e64ed2deed000000e8d4a51000"
WHITELIST1_ADDRESS="0xA904540818AC9c47f2321F97F1069B9d8746c6DB"
WHITELIST2_ADDRESS="0x316b2Fa7C8a2ab7E21110a4B3f58771C01A71344"

CMD=$1

# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
    --chainId)
        CHAIN_ID="$2"
        shift
        ;;
    --initConsensusStateBytes)
        INIT_CONSENSUS_STATE_BYTES="$2"
        shift
        ;;
    --whitelist1Address)
        WHITELIST1_ADDRESS="$2"
        shift
        ;;
    --whitelist2Address)
        WHITELIST2_ADDRESS="$2"
        shift
        ;;
    esac
    shift
done

HEX_CHAIN_ID=$(node -e "const hexChainID = require('./scripts/generate-chainId.js'); console.log(hexChainID($CHAIN_ID));")

function generate_local() {
    bash ${basedir}/generate-system.sh --hexChainId ${HEX_CHAIN_ID}
    bash ${basedir}/generate-crossChain.sh --hexChainId ${HEX_CHAIN_ID}
    bash ${basedir}/generate-relayerHub.sh --network local --whitelist1Address ${WHITELIST1_ADDRESS} --whitelist2Address ${WHITELIST2_ADDRESS}
    bash ${basedir}/generate-tendermintLightClient.sh --initConsensusStateBytes ${INIT_CONSENSUS_STATE_BYTES}
    bash ${basedir}/generate-validatorSet.sh --initBurnRatio 1000 --network local
    bash ${basedir}/generate-systemReward.sh --network local
    bash ${basedir}/generate-slashIndicator.sh --network local
    forge build
    node ${basedir}/generate-genesis.js --chainId ${CHAIN_ID}
}

function generate_QA() {
    bash ${basedir}/generate-system.sh --hexChainId 02ca
    bash ${basedir}/generate-crossChain.sh --hexChainId 02ca
    bash ${basedir}/generate-relayerHub.sh --network QA
    bash ${basedir}/generate-tendermintLightClient.sh --initConsensusStateBytes "42696e616e63652d436861696e2d47616e67657300000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000aea1ac326886b992a991d21a6eb155f41b77867cbf659e78f31d89d8205122a84d1be64f0e9a466c2e66a53433928192783e29f8fa21beb2133499b5ef770f60000000e8d4a5100099308aa365c40554bc89982af505d85da95251445d5dd4a9bb37dd2584fd92d3000000e8d4a5100001776920ff0b0f38d78cf95c033c21adf7045785114e392a7544179652e0a612000000e8d4a51000"
    bash ${basedir}/generate-validatorSet.sh --initBurnRatio 1000 --initValidatorSetBytes "f901a880f901a4f844941284214b9b9c85549ab3d2b972df0deef66ac2c9946ddf42a51534fc98d0c0a3b42c963cace8441ddf946ddf42a51534fc98d0c0a3b42c963cace8441ddf8410000000f84494a2959d3f95eae5dc7d70144ce1b73b403b7eb6e0948081ef03f1d9e0bb4a5bf38f16285c879299f07f948081ef03f1d9e0bb4a5bf38f16285c879299f07f8410000000f8449435552c16704d214347f29fa77f77da6d75d7c75294dc4973e838e3949c77aced16ac2315dc2d7ab11194dc4973e838e3949c77aced16ac2315dc2d7ab1118410000000f84494980a75ecd1309ea12fa2ed87a8744fbfc9b863d594cc6ac05c95a99c1f7b5f88de0e3486c82293b27094cc6ac05c95a99c1f7b5f88de0e3486c82293b2708410000000f84494f474cf03cceff28abc65c9cbae594f725c80e12d94e61a183325a18a173319dd8e19c8d069459e217594e61a183325a18a173319dd8e19c8d069459e21758410000000f84494b71b214cb885500844365e95cd9942c7276e7fd894d22ca3ba2141d23adab65ce4940eb7665ea2b6a794d22ca3ba2141d23adab65ce4940eb7665ea2b6a78410000000"
    forge build
    node ${basedir}/generate-genesis.js --chainId 714
}

function generate_testnet() {
    bash ${basedir}/generate-system.sh --hexChainId 0061
    bash ${basedir}/generate-crossChain.sh --hexChainId 0061
    bash ${basedir}/generate-relayerHub.sh --network testnet
    bash ${basedir}/generate-tendermintLightClient.sh --initConsensusStateBytes "42696e616e63652d436861696e2d47616e67657300000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000aea1ac326886b992a991d21a6eb155f41b77867cbf659e78f31d89d8205122a84d1be64f0e9a466c2e66a53433928192783e29f8fa21beb2133499b5ef770f60000000e8d4a5100099308aa365c40554bc89982af505d85da95251445d5dd4a9bb37dd2584fd92d3000000e8d4a5100001776920ff0b0f38d78cf95c033c21adf7045785114e392a7544179652e0a612000000e8d4a51000"
    bash ${basedir}/generate-validatorSet.sh --initBurnRatio 1000 --initValidatorSetBytes "f901a880f901a4f844941284214b9b9c85549ab3d2b972df0deef66ac2c9946ddf42a51534fc98d0c0a3b42c963cace8441ddf946ddf42a51534fc98d0c0a3b42c963cace8441ddf8410000000f84494a2959d3f95eae5dc7d70144ce1b73b403b7eb6e0948081ef03f1d9e0bb4a5bf38f16285c879299f07f948081ef03f1d9e0bb4a5bf38f16285c879299f07f8410000000f8449435552c16704d214347f29fa77f77da6d75d7c75294dc4973e838e3949c77aced16ac2315dc2d7ab11194dc4973e838e3949c77aced16ac2315dc2d7ab1118410000000f84494980a75ecd1309ea12fa2ed87a8744fbfc9b863d594cc6ac05c95a99c1f7b5f88de0e3486c82293b27094cc6ac05c95a99c1f7b5f88de0e3486c82293b2708410000000f84494f474cf03cceff28abc65c9cbae594f725c80e12d94e61a183325a18a173319dd8e19c8d069459e217594e61a183325a18a173319dd8e19c8d069459e21758410000000f84494b71b214cb885500844365e95cd9942c7276e7fd894d22ca3ba2141d23adab65ce4940eb7665ea2b6a794d22ca3ba2141d23adab65ce4940eb7665ea2b6a78410000000"
    forge build
    node ${basedir}/generate-genesis.js --chainId 97
}

function generate_mainnet() {
    bash ${basedir}/generate-system.sh --hexChainId 0038
    bash ${basedir}/generate-crossChain.sh --hexChainId 0038
    bash ${basedir}/generate-relayerHub.sh --network mainnet
    bash ${basedir}/generate-tendermintLightClient.sh --initConsensusStateBytes "42696e616e63652d436861696e2d5469677269730000000000000000000000000000000006915167cedaf7bbf7df47d932fdda630527ee648562cf3e52c5e5f46156a3a971a4ceb443c53a50d8653ef8cf1e5716da68120fb51b636dc6d111ec3277b098ecd42d49d3769d8a1f78b4c17a965f7a30d4181fabbd1f969f46d3c8e83b5ad4845421d8000000e8d4a510002ba4e81542f437b7ae1f8a35ddb233c789a8dc22734377d9b6d63af1ca403b61000000e8d4a51000df8da8c5abfdb38595391308bb71e5a1e0aabdc1d0cf38315d50d6be939b2606000000e8d4a51000b6619edca4143484800281d698b70c935e9152ad57b31d85c05f2f79f64b39f3000000e8d4a510009446d14ad86c8d2d74780b0847110001a1c2e252eedfea4753ebbbfce3a22f52000000e8d4a510000353c639f80cc8015944436dab1032245d44f912edc31ef668ff9f4a45cd0599000000e8d4a51000e81d3797e0544c3a718e1f05f0fb782212e248e784c1a851be87e77ae0db230e000000e8d4a510005e3fcda30bd19d45c4b73688da35e7da1fce7c6859b2c1f20ed5202d24144e3e000000e8d4a51000b06a59a2d75bf5d014fce7c999b5e71e7a960870f725847d4ba3235baeaa08ef000000e8d4a510000c910e2fe650e4e01406b3310b489fb60a84bc3ff5c5bee3a56d5898b6a8af32000000e8d4a5100071f2d7b8ec1c8b99a653429b0118cd201f794f409d0fea4d65b1b662f2b00063000000e8d4a51000"
    bash ${basedir}/generate-validatorSet.sh --initBurnRatio 1000 --initValidatorSetBytes "f905ec80f905e8f846942a7cdd959bfe8d9487b2a43b33565295a698f7e294b6a7edd747c0554875d3fc531d19ba1497992c5e941ff80f3f7f110ffd8920a3ac38fdef318fe94a3f86048c27395000f846946488aa4d1955ee33403f8ccb1d4de5fb97c7ade294220f003d8bdfaadf52aa1e55ae4cc485e6794875941a87e90e440a39c99aa9cb5cea0ad6a3f0b2407b86048c27395000f846949ef9f4360c606c7ab4db26b016007d3ad0ab86a0946103af86a874b705854033438383c82575f25bc29418e2db06cbff3e3c5f856410a1838649e760175786048c27395000f84694ee01c3b1283aa067c58eab4709f85e99d46de5fe94ee4b9bfb1871c64e2bcabb1dc382dc8b7c4218a29415904ab26ab0e99d70b51c220ccdcccabee6e29786048c27395000f84694685b1ded8013785d6623cc18d214320b6bb6475994a20ef4e5e4e7e36258dbf51f4d905114cb1b34bc9413e39085dc88704f4394d35209a02b1a9520320c86048c27395000f8469478f3adfc719c99674c072166708589033e2d9afe9448a30d5eaa7b64492a160f139e2da2800ec3834e94055838358c29edf4dcc1ba1985ad58aedbb6be2b86048c27395000f84694c2be4ec20253b8642161bc3f444f53679c1f3d479466f50c616d737e60d7ca6311ff0d9c434197898a94d1d678a2506eeaa365056fe565df8bc8659f28b086048c27395000f846942f7be8361c80a4c1e7e9aaf001d0877f1cfde218945f93992ac37f3e61db2ef8a587a436a161fd210b94ecbc4fb1a97861344dad0867ca3cba2b860411f086048c27395000f84694ce2fd7544e0b2cc94692d4a704debef7bcb613289444abc67b4b2fba283c582387f54c9cba7c34bafa948acc2ab395ded08bb75ce85bf0f95ad2abc51ad586048c27395000f84694b8f7166496996a7da21cf1f1b04d9b3e26a3d077946770572763289aac606e4f327c2f6cc1aa3b3e3b94882d745ed97d4422ca8da1c22ec49d880c4c097286048c27395000f846942d4c407bbe49438ed859fe965b140dcf1aab71a9943ad0939e120f33518fbba04631afe7a3ed6327b194b2bbb170ca4e499a2b0f3cc85ebfa6e8c4dfcbea86048c27395000f846946bbad7cf34b5fa511d8e963dbba288b1960e75d694853b0f6c324d1f4e76c8266942337ac1b0af1a229442498946a51ca5924552ead6fc2af08b94fcba648601d1a94a2000f846944430b3230294d12c6ab2aac5c2cd68e80b16b581947b107f4976a252a6939b771202c28e64e03f52d694795811a7f214084116949fc4f53cedbf189eeab28601d1a94a2000f84694ea0a6e3c511bbd10f4519ece37dc24887e11b55d946811ca77acfb221a49393c193f3a22db829fcc8e9464feb7c04830dd9ace164fc5c52b3f5a29e5018a8601d1a94a2000f846947ae2f5b9e386cd1b50a4550696d957cb4900f03a94e83bcc5077e6b873995c24bac871b5ad856047e19464e48d4057a90b233e026c1041e6012ada897fe88601d1a94a2000f8469482012708dafc9e1b880fd083b32182b869be8e09948e5adc73a2d233a1b496ed3115464dd6c7b887509428b383d324bc9a37f4e276190796ba5a8947f5ed8601d1a94a2000f8469422b81f8e175ffde54d797fe11eb03f9e3bf75f1d94a1c3ef7ca38d8ba80cce3bfc53ebd2903ed21658942767f7447f7b9b70313d4147b795414aecea54718601d1a94a2000f8469468bf0b8b6fb4e317a0f9d6f03eaf8ce6675bc60d94675cfe570b7902623f47e7f59c9664b5f5065dcf94d84f0d2e50bcf00f2fc476e1c57f5ca2d57f625b8601d1a94a2000f846948c4d90829ce8f72d0163c1d5cf348a862d5506309485c42a7b34309bee2ed6a235f86d16f059deec5894cc2cedc53f0fa6d376336efb67e43d167169f3b78601d1a94a2000f8469435e7a025f4da968de7e4d7e4004197917f4070f194b1182abaeeb3b4d8eba7e6a4162eac7ace23d57394c4fd0d870da52e73de2dd8ded19fe3d26f43a1138601d1a94a2000f84694d6caa02bbebaebb5d7e581e4b66559e635f805ff94c07335cf083c1c46a487f0325769d88e163b653694efaff03b42e41f953a925fc43720e45fb61a19938601d1a94a2000"
    forge build
    node ${basedir}/generate-genesis.js --chainId 56
}

case ${CMD} in
local)
    echo "===== generate genesis of local ====="
    generate_local
    echo -e "\n===== end ====="
    ;;
QA)
    echo "===== generate genesis of QA ====="
    generate_QA
    echo -e "\n===== end ====="
    ;;
testnet)
    echo "===== generate genesis of testnet ====="
    generate_testnet
    echo -e "\n===== end ====="
    ;;
mainnet)
    echo "===== generate genesis of mainnet ====="
    generate_mainnet
    echo -e "\n===== end ====="
    ;;
*)
    echo "Usage: generate.sh local | QA | testnet | mainnet"
    ;;
esac
