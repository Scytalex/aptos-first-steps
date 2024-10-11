// modulo de biblioteca donde se agregan, modifica, elimina y se consulta libros. (solo el firmante podra realizar estas acciones)

module account::biblioteca {
    use aptos_std::table::{Self, Table};
    use std::string::String;
    use std::option::{Self, Option, is_some};
    use std::signer::address_of;

    const YA_INICIALIZADO: u64 = 1;
    const NO_INICIALIZADO: u64 = 2;
    const REGISTRO_NO_EXISTE: u64 = 3;
    const REGISTRO_YA_EXISTE: u64 = 4;
    const NADA_A_MODIFICAR: u64 = 5;

	struct Titulo has copy, drop {
		titulo: String,
	}

	struct Libro has store, copy, drop { // estructura del libro

		autor: String,
		editorial: String,
		fecha_publicacion: String,
		categoria: String,
		
	}

	struct Biblioteca has key { // estructura donde se almacenara todos los libros
	
		libros: Table<Titulo, Libro>
	}

	public entry fun inicializar (account: &signer) {
		assert!(!exists<Biblioteca>(address_of(account)), YA_INICIALIZADO);
		move_to(account,Biblioteca{
		    libros: table::new<Titulo, Libro>(),
	})
}

	public entry fun agregar_libro(
		account: &signer,
		titulo: String,
		autor: String,
		editorial: String,
		fecha_publicacion: String,
		categoria: String,	
	) acquires Biblioteca {
		assert!(exists<Biblioteca>(address_of(account)),NO_INICIALIZADO);
        
        let libros = borrow_global_mut<Biblioteca>(address_of(account));
        assert!(!table::contains(&libros.libros, Titulo { titulo }), REGISTRO_YA_EXISTE);

        table::add(&mut libros.libros, Titulo {
            titulo,
        }, Libro {
            autor,
            editorial,
            fecha_publicacion,
            categoria
        } );	
		
}

#[view]
public fun obtener_libro(account: address, titulo: String): Libro acquires Biblioteca {
	assert!(exists<Biblioteca>(account), NO_INICIALIZADO);

	let libros = borrow_global<Biblioteca>(account);
	let resultado = table::borrow(&libros.libros, Titulo {titulo});
	*resultado

}

public entry fun modificar_autor (account:&signer, titulo:String, autor:String) acquires Bliblioteca {
    assert!(exists<Biblioteca>(address_of(account)), NO_INICIALIZADO);
    let libros = borrow_global_mut<Biblioteca>(address_of(account));

    assert!(table::contains(&libros.libros, Titulo {titulo}),REGISTRO_NO_EXISTE);
    let autor_actual = &mut table::borrow_mut(&mut libros.libros, Titulo {titulo}).autor;
    *autor_actual=autor;
}
}