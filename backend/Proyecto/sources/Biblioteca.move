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

public entry fun modificar_autor (account:&signer, titulo:String, autor:String) acquires Biblioteca {
    assert!(exists<Biblioteca>(address_of(account)), NO_INICIALIZADO);
    let libros = borrow_global_mut<Biblioteca>(address_of(account));

    assert!(table::contains(&libros.libros, Titulo {titulo}),REGISTRO_NO_EXISTE);
    let autor_actual = &mut table::borrow_mut(&mut libros.libros, Titulo {titulo}).autor;
    *autor_actual=autor;
}

public entry fun modificar_editorial (account:&signer, titulo:String, editorial:String) acquires Biblioteca{
	assert!(exists<Biblioteca>(address_of(account)), NO_INICIALIZADO);
	let libros = borrow_global_mut<Biblioteca>(address_of(account));

	assert!(table::contains(&libros.libros, Titulo{titulo}),REGISTRO_NO_EXISTE);
	let editorial_actual = &mut table ::borrow_mut(&mut libros.libros, Titulo {titulo}).editorial;
	*editorial_actual=editorial;
}

public entry fun modificar_fecha_publicacion (account:&signer, titulo:String, fecha_publicacion:String) acquires Biblioteca{
	assert!(exists<Biblioteca>(address_of(account)), NO_INICIALIZADO);
	let libros = borrow_global_mut<Biblioteca>(address_of(account));

	assert!(table::contains(&libros.libros, Titulo{titulo}),REGISTRO_NO_EXISTE);
	let fecha_publicacion_actual = &mut table ::borrow_mut(&mut libros.libros, Titulo {titulo}).fecha_publicacion;
	*fecha_publicacion_actual=fecha_publicacion;
}

public entry fun modificar_categoria (account:&signer, titulo:String, categoria:String) acquires Biblioteca{
	assert!(exists<Biblioteca>(address_of(account)), NO_INICIALIZADO);
	let libros = borrow_global_mut<Biblioteca>(address_of(account));

	assert!(table::contains(&libros.libros, Titulo{titulo}),REGISTRO_NO_EXISTE);
	let categoria_actual = &mut table ::borrow_mut(&mut libros.libros, Titulo {titulo}).categoria;
	*categoria_actual=categoria;

} public entry fun modificar_libro(
	account: &signer,
	titulo: String,
	autor: Option<String>,
	editorial:Option<String>, 
	fecha_publicacion: Option<String>,
	categoria: Option<String>,
)  acquires Biblioteca {
	assert!(exists<Biblioteca>(address_of(account)), NO_INICIALIZADO);
	assert!(is_some(&autor) || is_some(&editorial) || is_some(&fecha_publicacion) || is_some(&categoria), NADA_A_MODIFICAR );

	let libros = borrow_global_mut<Biblioteca>(address_of(account));

	assert! (table::contains(&libros.libros,Titulo {titulo}), REGISTRO_NO_EXISTE);
	let libros = table::borrow_mut(&mut libros.libros, Titulo {titulo});

	if (is_some(&autor)) libros.autor = *option::borrow(&autor);
	if (is_some(&editorial)) libros.editorial = *option::borrow(&editorial);
	if (is_some(&fecha_publicacion)) libros.fecha_publicacion = *option::borrow(&fecha_publicacion);
	if (is_some(&categoria)) libros.categoria = *option::borrow(&categoria);

}
   
}
