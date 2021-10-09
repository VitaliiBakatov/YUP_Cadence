import NonFungibleToken from "./NonFungibleToken.cdc"
import YUP from "./NonFungibleToken.cdc"

transaction(flowKey: String) {
    prepare(signer: AuthAccount) {
        let account = AuthAccount(payer: signer)
        account.addPublicKey(flowKey.decodeHex())
        var i = 0
        while i < 10 {
            i = i + 1
            account.addPublicKey(flowKey.decodeHex())
        }
        let collection <- YUP.createEmptyCollection()
        account.save(<-collection, to: YUP.CollectionStoragePath)
        account.link<&YUP.Collection{NonFungibleToken.CollectionPublic, YUP.YUPCollectionPublic}>(YUP.CollectionPublicPath, target: YUP.CollectionStoragePath)
    }

}
