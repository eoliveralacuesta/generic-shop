(function () {
    let header, isScrolled;

    // === HEADER STICKY ===
    function checkHeaderSticky() {
        if (!header)
            header = document.querySelector("header");

        if (!header)
            return;

        const scrollPos = window.scrollY;
        if (!isScrolled && scrollPos > 250) {
            header.classList.add("scrolled");
            isScrolled = true;
        } else if (isScrolled && scrollPos < 150) {
            header.classList.remove("scrolled");
            isScrolled = false;
        }
    }

    // === ANIMACIONES IN-VIEW ===
    const observer = new IntersectionObserver(
        (entries) => {
            entries.forEach(entry => {
                const el = entry.target;
                if (entry.isIntersecting) {
                    el.classList.add("animating");
                    el.addEventListener(
                        "animationend",
                        () => el.classList.remove("animating"),
                        { once: true }
                    );
                }
            });
        },
        {
            threshold: 0.5,
            rootMargin: "0px 0px -10% 0px"
        }
    );

    const animElems = document.querySelectorAll('[class*="animation--"]');
    animElems.forEach(el => observer.observe(el));

    function triggerInitialAnimations() {
        const vh = window.innerHeight || document.documentElement.clientHeight;
        animElems.forEach(el => {
            const rect = el.getBoundingClientRect();
            if (rect.top < vh && rect.bottom > 0) {
                el.classList.add("animating");
                el.addEventListener(
                    "animationend",
                    () => el.classList.remove("animating"),
                    { once: true }
                );
            }
        });
    }

    // === MENÚ HAMBURGUESA ===
    const menuToggle = document.getElementById("menu-toggle");
    const menuLinks = document.querySelectorAll("#header__navigation a");

    function toggleMenu(forceClose = false) {
        const isOpen = document.body.classList.contains("menu-open");

        if (forceClose || isOpen) {
            document.body.classList.remove("menu-open");
        } else {
            document.body.classList.add("menu-open");
        }
    }

    if (menuToggle) {
        menuToggle.addEventListener("click", () => toggleMenu());
    }
    menuLinks.forEach(link => {
        link.addEventListener("click", () => toggleMenu(true));
    });

    // === EVENTOS ===
    window.addEventListener("scroll", checkHeaderSticky);

    if (document.readyState === "complete") {
        checkHeaderSticky();
        triggerInitialAnimations();
    } else {
        window.addEventListener("load", () => {
            checkHeaderSticky();
            triggerInitialAnimations();
        });
    }


    document.getElementById('catalog-download').addEventListener('click', async function (e) {
        e.preventDefault();
        //Comento funcionamiento viejo que simplemente lo levanta de la carpeta correspondiente, porque es una web estática
        //const response = await fetch(this.href);
        //const blob = await response.blob();
        //const url = URL.createObjectURL(blob);

        //Ahora son necesarios varios pasos
        // 1 - Pedir el token
        const { token } = await (await fetch('/api/auth')).json();

        // 2 - Preparar la URL para hacer el request
        const u = new URL('/api/catalog', location.origin);
        u.searchParams.set('token', token);

        // 3 - Pedir el archivo con el token correspondiente
        const res = await fetch(u);
        if (!res.ok) { alert('No autorizado'); return; }

        // 4 - Descargar el archivo
        const blob = await res.blob();
        const url = URL.createObjectURL(blob);

        const a = document.createElement('a');
        a.href = url;
        a.download = 'Lumbra 2025.pdf';
        document.body.appendChild(a);
        a.click();
        a.remove();
        
        URL.revokeObjectURL(url);
    });
})();
