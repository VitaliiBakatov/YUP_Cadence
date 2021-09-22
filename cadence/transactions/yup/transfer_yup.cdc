import NonFungibleToken from 0x8b53b4e7951b6c13
import YUP from 0x8b53b4e7951b6c13

transaction(recipient: Address, withdrawID: UInt64) {
    prepare(signer: AuthAccount) {

        let recipient = getAccount(recipient)

        let collectionRef = signer.borrow<&YUP.Collection>(from: YUP.CollectionStoragePath)
            ?? panic("Could not borrow a reference to the owner's collection")

        let depositRef = recipient.getCapability(YUP.CollectionPublicPath)!.borrow<&{NonFungibleToken.CollectionPublic}>()!

        let nft <- collectionRef.withdraw(withdrawID: withdrawID)

        depositRef.deposit(token: <-nft)
    }
}

