export interface User {
    id: number;
    username: string;
    email: string;
    role: {
        id: number;
        name: string;
    };
}

export interface AuthState {
    user: User | null;
    xsrfToken: string | null;
    roles: string[]; // Ajoutez les rôles
    permissions: string[]; // Ajoutez les permissions`
    loginTimestamp: string | null;
}