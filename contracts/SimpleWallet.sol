// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleWallet {
    // ====================================================================
    // 1. Variabel Keadaan (State Variables)
    // ====================================================================

    // Alamat pemilik kontrak (yang mendeploy)
    address public owner;

    // Mapping untuk melacak saldo internal setiap alamat.
    // Ini bukan saldo Ether kontrak, melainkan saldo 'token' internal
    // yang dikelola oleh logika kontrak ini.
    mapping(address => uint) public balances;

    // ====================================================================
    // 2. Events (Untuk Logging Transaksi)
    // ====================================================================

    // Event yang di-emit saat Ether disetor ke kontrak
    event EtherDeposited(address indexed user, uint amount);
    // Event yang di-emit saat saldo internal ditransfer antar pengguna
    event InternalBalanceTransferred(address indexed from, address indexed to, uint amount);
    // Event yang di-emit saat Ether ditarik dari kontrak oleh pemilik
    event EtherWithdrawn(address indexed to, uint amount);

    // ====================================================================
    // 3. Modifiers (Untuk Kontrol Akses)
    // ====================================================================

    // Modifier yang membatasi fungsi hanya bisa dipanggil oleh pemilik kontrak
    modifier onlyOwner() {
        require(msg.sender == owner, "Hanya pemilik yang bisa memanggil fungsi ini.");
        _; // Placeholder untuk kode fungsi yang menggunakan modifier ini
    }

    // ====================================================================
    // 4. Constructor
    // ====================================================================

    // Constructor: Dijalankan sekali saat kontrak di-deploy.
    // Menginisialisasi pemilik kontrak.
    constructor() {
        owner = msg.sender; // Pemilik adalah alamat yang mendeploy kontrak
        // Memberi saldo internal awal kepada pemilik (misalnya 1000 unit)
        balances[owner] = 1000;
    }

    // ====================================================================
    // 5. Fungsi Penerima Ether Khusus
    // ====================================================================

    // Fungsi 'receive' (external dan payable)
    // Ini adalah fungsi khusus yang dieksekusi ketika kontrak menerima Ether
    // tanpa ada data panggilan fungsi (pure Ether transfer).
    // Misalnya, jika seseorang mengirim Ether langsung ke alamat kontrak.
    receive() external payable {
        // Tambahkan jumlah Ether yang diterima ke saldo internal pengirim
        balances[msg.sender] += msg.value;
        emit EtherDeposited(msg.sender, msg.value);
    }

    // Fungsi 'fallback' (external dan payable)
    // Ini adalah fungsi khusus yang dieksekusi ketika:
    // 1. Kontrak menerima panggilan ke fungsi yang tidak ada.
    // 2. Kontrak menerima Ether dengan data, dan fungsi 'receive' tidak ada.
    // 3. Kontrak menerima Ether tanpa data, dan fungsi 'receive' tidak ada.
    fallback() external payable {
        // Dalam kasus ini, kita akan memperlakukannya seperti deposit juga
        balances[msg.sender] += msg.value;
        emit EtherDeposited(msg.sender, msg.value);
    }

    // ====================================================================
    // 6. Fungsi Utama
    // ====================================================================

    // Fungsi untuk menyetor Ether ke kontrak.
    // 'payable' memungkinkan fungsi ini menerima Ether yang dikirim bersama transaksi.
    function deposit() public payable {
        // Tambahkan jumlah Ether yang diterima ke saldo internal pengirim.
        // Ini mengasumsikan 1 Wei Ether setara dengan 1 unit saldo internal.
        balances[msg.sender] += msg.value;
        emit EtherDeposited(msg.sender, msg.value);
    }

    // Fungsi untuk mentransfer saldo internal antar pengguna.
    // Ini hanya memindahkan saldo di dalam mapping kontrak, bukan Ether yang sebenarnya.
    function transferInternalBalance(address _to, uint _amount) public {
        // Validasi: Memastikan pengirim memiliki saldo internal yang cukup.
        require(balances[msg.sender] >= _amount, "Saldo internal tidak cukup.");
        // Validasi: Memastikan alamat tujuan tidak nol.
        require(_to != address(0), "Alamat tujuan tidak valid.");
        // Validasi: Memastikan pengirim dan penerima bukan alamat yang sama.
        require(msg.sender != _to, "Tidak bisa transfer ke diri sendiri.");

        // Kurangi saldo internal pengirim.
        balances[msg.sender] -= _amount;
        // Tambahkan saldo internal penerima.
        balances[_to] += _amount;

        emit InternalBalanceTransferred(msg.sender, _to, _amount);
    }

    // Fungsi untuk menarik Ether yang sebenarnya dari saldo kontrak.
    // Hanya pemilik yang dapat memanggil fungsi ini (menggunakan modifier onlyOwner).
    function withdrawEther(address payable _to, uint _amount) public onlyOwner {
        // Validasi: Memastikan kontrak memiliki cukup Ether untuk ditarik.
        require(address(this).balance >= _amount, "Dana kontrak tidak cukup.");
        // Validasi: Memastikan alamat tujuan tidak nol.
        require(_to != address(0), "Alamat tujuan tidak valid.");

        // Melakukan transfer Ether.
        // '.transfer()' adalah metode yang aman untuk mengirim Ether.
        _to.transfer(_amount);
        emit EtherWithdrawn(_to, _amount);
    }

    // Fungsi untuk mendapatkan saldo Ether kontrak.
    function getContractEtherBalance() public view returns (uint) {
        return address(this).balance;
    }

    // Fungsi untuk mendapatkan saldo internal pengguna tertentu.
    // Karena 'balances' adalah 'public', compiler sudah membuat fungsi getter otomatis.
    // Namun, kita bisa membuat wrapper eksplisit untuk kejelasan.
    function getMyInternalBalance() public view returns (uint) {
        return balances[msg.sender];
    }
}