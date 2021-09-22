import NonFungibleToken from 0x8b53b4e7951b6c13
import YUP from 0x8b53b4e7951b6c13

transaction(recipient: Address, influencerID: UInt32, editionID: UInt32, serialNumber: UInt32, url: String) {

    let minter: &YUP.NFTMinter

    prepare(signer: AuthAccount) {

        self.minter = signer.borrow<&YUP.NFTMinter>(from: YUP.MinterStoragePath)
            ?? panic("Could not borrow a reference to the NFT minter")
    }

    execute {
        let recipient = getAccount(recipient)

        let receiver = recipient
            .getCapability(YUP.CollectionPublicPath)!
            .borrow<&{NonFungibleToken.CollectionPublic}>()
            ?? panic("Could not get receiver reference to the NFT Collection")

        self.minter.mintYUP(recipient: receiver, influencerID: influencerID, editionID: editionID, serialNumber: serialNumber, url: url)
    }
}
