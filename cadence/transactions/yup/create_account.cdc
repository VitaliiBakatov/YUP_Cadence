import NonFungibleToken from 0x8b53b4e7951b6c13
import YUP from 0x8b53b4e7951b6c13

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