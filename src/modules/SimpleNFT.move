module 0x2c5bd5fb513108d4557107e09c51656c::SimpleNFT{
	use 0x1::NFT::{Self, NFT, MintCapability, BurnCapability, UpdateCapability, Metadata};
	use 0x1::Signer;
	use 0x1::NFTGallery;

	struct SimpleNFT has copy,store,drop{
	}

	struct SimpleNFTBody has store{}

	struct SimpleNFTInfo has copy,store,drop{
	}

	struct SimpleNFTMintCapability has key{
        	cap: MintCapability<SimpleNFT>,
    	}

    	struct SimpleNFTBurnCapability has key{
        	cap: BurnCapability<SimpleNFT>,
    	}

    	struct SimpleNFTUpdateCapability has key{
        	cap: UpdateCapability<SimpleNFT>,
    	}

	const CONTRACT_ACCOUNT:address = @0x2c5bd5fb513108d4557107e09c51656c;

	public fun initialize(sender: &signer) {
		assert(Signer::address_of(sender)==CONTRACT_ACCOUNT, 101);
		
		if(!exists<SimpleNFTMintCapability>(CONTRACT_ACCOUNT)) {
			let meta = NFT::new_meta(b"SimpleNFT", b"A NFT example, everyone can mint a SimpleNFT");
			NFT::register<SimpleNFT,SimpleNFTInfo>(sender, SimpleNFTInfo{}, meta);
			let cap = NFT::remove_mint_capability<SimpleNFT>(sender);
        		move_to(sender, SimpleNFTMintCapability{ cap});

        		let cap = NFT::remove_burn_capability<SimpleNFT>(sender);
        		move_to(sender, SimpleNFTBurnCapability{ cap});

        		let cap = NFT::remove_update_capability<SimpleNFT>(sender);
        		move_to(sender, SimpleNFTUpdateCapability{ cap});
		}
	}

	public fun mint(sender: &signer, metadata: Metadata): NFT<SimpleNFT, SimpleNFTBody> acquires SimpleNFTMintCapability{
		let mint_cap = borrow_global_mut<SimpleNFTMintCapability>(CONTRACT_ACCOUNT);
		let nft = NFT::mint_with_cap<SimpleNFT,SimpleNFTBody,SimpleNFTInfo>(Signer::address_of(sender), &mut mint_cap.cap, metadata, SimpleNFT{}, SimpleNFTBody{});
		nft
	}

	public fun accept(sender: &signer){
		NFTGallery::accept<SimpleNFT, SimpleNFTBody>(sender);
	}
}

module 0x2c5bd5fb513108d4557107e09c51656c::SimpleNFTScripts{
	use 0x1::NFT;
	use 0x1::NFTGallery;
	use 0x2c5bd5fb513108d4557107e09c51656c::SimpleNFT;

	public(script) fun initialize(sender: signer) {
		SimpleNFT::initialize(&sender);
	}

	public(script) fun mint_with_image(sender: signer, name: vector<u8>, image_url: vector<u8>, description: vector<u8>){
		let metadata = NFT::new_meta_with_image(name, image_url, description);
		let nft = SimpleNFT::mint(&sender,metadata);
		SimpleNFT::accept(&sender);
		NFTGallery::deposit(&sender, nft);
	}

	public(script) fun mint_with_image_data(sender: signer, name: vector<u8>, image_data: vector<u8>, description: vector<u8>){
		let metadata = NFT::new_meta_with_image_data(name, image_data, description);
		let nft = SimpleNFT::mint(&sender,metadata);
		SimpleNFT::accept(&sender);
		NFTGallery::deposit(&sender, nft);
	}
}