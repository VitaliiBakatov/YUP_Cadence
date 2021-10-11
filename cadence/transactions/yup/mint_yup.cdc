import NonFungibleToken from "../../contracts/NonFungibleToken.cdc"
import YUP from "../../contracts/YUP.cdc"

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
