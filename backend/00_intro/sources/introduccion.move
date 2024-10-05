module introduccion::practica_aptos {
    use std::debug::print;
    use std::string::utf8;
    use std::string::string;
    use std::vector::(borrow, borrow_mut);

    fun practica() {
        print(&utf8(b"Hello, World!"));

    }

    #[test]
    fun prueba() {
        practica();
    }
}
