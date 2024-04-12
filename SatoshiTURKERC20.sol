// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title SatoshiTURK için Gelistirilmis ERC20 Tokeni
 * @dev Ek guvenlik onlemleri, mint (yeni token uretme), burn (token yok etme),
 * pause (duraklatma) ve unpause (duraklatmayi kaldirma) islevleri iceren ERC20 Tokeni.
 * Balina hareketlerini onlemek icin maksimum islem miktari ayari icermektedir.
 */
contract SatoshiTURKERC20 {
    string public name; // Tokenin adi
    string public symbol; // Tokenin sembolu
    uint8 public decimals = 18; // Tokenin ondalik basamak sayisi, standart ERC20 icin 18 kullanilir
    uint256 private _totalSupply; // Tokenlarin toplam arzi

    mapping(address => uint256) private _balances; // Adreslerin token bakiyelerini tutan mapping
    mapping(address => mapping(address => uint256)) private _allowances; // Transfer izinlerini tutan mapping

    address public contractOwner; // Kontrat sahibinin adresi
    bool public paused = false; // Kontratin duraklatilip duraklatilmadigini belirten bayrak
    uint256 public maxTxAmount; // Balina aktivitelerini onlemek icin islemlerde maksimum miktar

    // Events (Olaylar)
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed tokenOwner, address indexed spender, uint256 value);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event Paused();
    event Unpaused();
    event Mint(address indexed to, uint256 amount);
    event Burn(address indexed from, uint256 amount);

    // Modifiers (Degistiriciler)
    modifier onlyOwner() {
        require(msg.sender == contractOwner, "Cagiran kisi sahip degil");
        _;
    }

    modifier whenNotPaused() {
        require(!paused, "Kontrat duraklatilmis");
        _;
    }

    modifier whenPaused() {
        require(paused, "Kontrat duraklatilmamis");
        _;
    }

    // Constructor to initialize the token
    constructor(string memory _name, string memory _symbol, uint256 _maxTxAmount) {
        name = _name; // Token adini ayarla
        symbol = _symbol; // Token sembolunu ayarla
        contractOwner = msg.sender; // Kontrat sahibini ayarla
        maxTxAmount = _maxTxAmount; // Maksimum islem miktarini ayarla
    }

    // Toplam arzi dondurur
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    // Belirli bir hesabin token bakiyesini dondurur
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    // Belirli bir adrese token transferi yapar
    function transfer(address recipient, uint256 amount) public whenNotPaused returns (bool) {
        require(amount <= maxTxAmount, "Transfer miktari maksimum miktari asiyor");
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    // Bir harcayiciya ne kadar miktarin hala cekilebilecegini dondurur
    function allowance(address tokenOwner, address spender) public view returns (uint256) {
        return _allowances[tokenOwner][spender];
    }

    // Bir harcayicinin hesabinizdan belirli bir miktarı birden fazla kez cekmesine izin verir
    function approve(address spender, uint256 amount) public whenNotPaused returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    // Sahibin adina token transferi yapar
    function transferFrom(address sender, address recipient, uint256 amount) public whenNotPaused returns (bool) {
        require(amount <= maxTxAmount, "Transfer miktari maksimum miktari asiyor");
        _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);
        _transfer(sender, recipient, amount);
        return true;
    }

    // Yeni tokenler yaratir ve bunlari bir hesaba atar
    function mint(address account, uint256 amount) public onlyOwner {
        require(account != address(0), "Sifir adrese mint yapilamaz");
        require(amount <= maxTxAmount, "Mint miktari maksimum miktari asiyor");
        _totalSupply += amount;
        _balances[account] += amount;
        emit Mint(account, amount);
        emit Transfer(address(0), account, amount);
    }

    // Bir hesaptan tokenleri yok eder
    function burn(uint256 amount) public {
        require(_balances[msg.sender] >= amount, "Yok etme miktari bakiyeyi asiyor");
        require(amount <= maxTxAmount, "Yok etme miktari maksimum miktari asiyor");
        _balances[msg.sender] -= amount;
        _totalSupply -= amount;
        emit Burn(msg.sender, amount);
        emit Transfer(msg.sender, address(0), amount);
    }

    // Kontrat islevlerini duraklatir
    function pause() public onlyOwner whenNotPaused {
        paused = true;
        emit Paused();
    }

    // Kontrat islevlerinin duraklatilmasini kaldirir
    function unpause() public onlyOwner whenPaused {
        paused = false;
        emit Unpaused();
    }

    // Kontrat sahipligini yeni bir adrese aktarir
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Yeni sahip sifir adres olamaz");
        emit OwnershipTransferred(contractOwner, newOwner);
        contractOwner = newOwner;
    }

    // Dahili transfer islevi
    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "Sifir adresten transfer yapilamaz");
        require(recipient != address(0), "Sifir adrese transfer yapilamaz");
        require(_balances[sender] >= amount, "Transfer miktari bakiyeyi asiyor");

        _balances[sender] -= amount;
        _balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
    }

    // Dahili onay islevi
    function _approve(address tokenOwner, address spender, uint256 amount) internal {
        require(tokenOwner != address(0), "Onay sifir adresten yapilamaz");
        require(spender != address(0), "Onay sifir adrese verilemez");

        _allowances[tokenOwner][spender] = amount;
        emit Approval(tokenOwner, spender, amount);
    }
}
