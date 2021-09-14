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
			let meta = NFT::new_meta_with_image_data(b"SimpleNFT", b"data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiIHN0YW5kYWxvbmU9InllcyI/Pgo8IURPQ1RZUEUgc3ZnIFBVQkxJQyAiLS8vVzNDLy9EVEQgU1ZHIDEuMS8vRU4iICJodHRwOi8vd3d3LnczLm9yZy9HcmFwaGljcy9TVkcvMS4xL0RURC9zdmcxMS5kdGQiPgo8c3ZnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgeG1sbnM6eGxpbms9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsiIHhtbG5zOmRjPSJodHRwOi8vcHVybC5vcmcvZGMvZWxlbWVudHMvMS4xLyIgeG1sbnM6Y2M9Imh0dHA6Ly93ZWIucmVzb3VyY2Uub3JnL2NjLyIgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIiB4bWxuczpzb2RpcG9kaT0iaHR0cDovL3NvZGlwb2RpLnNvdXJjZWZvcmdlLm5ldC9EVEQvc29kaXBvZGktMC5kdGQiIHhtbG5zOmlua3NjYXBlPSJodHRwOi8vd3d3Lmlua3NjYXBlLm9yZy9uYW1lc3BhY2VzL2lua3NjYXBlIiB2ZXJzaW9uPSIxLjEiIGJhc2VQcm9maWxlPSJmdWxsIiB3aWR0aD0iMTUwcHgiIGhlaWdodD0iMTUwcHgiIHZpZXdCb3g9IjAgMCAxNTAgMTUwIiBwcmVzZXJ2ZUFzcGVjdFJhdGlvPSJ4TWlkWU1pZCBtZWV0IiBpZD0ic3ZnX2RvY3VtZW50IiBzdHlsZT0iem9vbTogMTsiPjwhLS0gQ3JlYXRlZCB3aXRoIG1hY1NWRyAtIGh0dHBzOi8vbWFjc3ZnLm9yZy8gLSBodHRwczovL2dpdGh1Yi5jb20vZHN3YXJkMi9tYWNzdmcvIC0tPjx0aXRsZSBpZD0ic3ZnX2RvY3VtZW50X3RpdGxlIj5VbnRpdGxlZC5zdmc8L3RpdGxlPjxkZWZzIGlkPSJzdmdfZG9jdW1lbnRfZGVmcyI+PC9kZWZzPjxnIGlkPSJtYWluX2dyb3VwIj48cmVjdCBpZD0iYmFja2dyb3VuZF9yZWN0IiBmaWxsPSIjMTU4OGYxIiB4PSIwcHgiIHk9IjBweCIgd2lkdGg9IjE1MHB4IiBoZWlnaHQ9IjE1MHB4Ij48L3JlY3Q+PC9nPjwvc3ZnPg==", b"A NFT example, everyone can mint a SimpleNFT");
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

	public fun upgrade_to_nft_type_info_v2(sender: &signer) acquires SimpleNFTMintCapability {
		assert(Signer::address_of(sender)==CONTRACT_ACCOUNT, 101);
		let cap = borrow_global_mut<SimpleNFTMintCapability>(CONTRACT_ACCOUNT);
        	NFT::upgrade_nft_type_info_from_v1_to_v2<SimpleNFT, SimpleNFTInfo>(sender, &mut cap.cap);
        	let _nft_info = NFT::remove_compat_info<SimpleNFT, SimpleNFTInfo>(&mut cap.cap);
        	//drop nft_info
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

	public(script) fun upgrade_to_nft_type_info_v2(sender: signer){
		SimpleNFT::upgrade_to_nft_type_info_v2(&sender);
	}
}