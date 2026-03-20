import { render, screen, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import App from './App';
import { seedAuthUser } from './services/authService';

describe('App auth flows', () => {
  it('validates registration form and shows onboarding redirect after success', async () => {
    const user = userEvent.setup();
    render(<App />);

    await user.click(screen.getByRole('button', { name: 'Załóż konto' }));
    expect(await screen.findByText('Email jest wymagany.')).toBeInTheDocument();

    await user.type(screen.getByLabelText('Email'), 'new.runner@example.com');
    await user.type(screen.getByLabelText('Hasło'), 'password123');
    await user.type(screen.getByLabelText('Powtórz hasło'), 'password123');
    await user.click(screen.getByRole('button', { name: 'Załóż konto' }));

    expect(await screen.findByText(/Redirect:/)).toHaveTextContent('/onboarding');
  });

  it('logs in existing user and shows dashboard redirect', async () => {
    seedAuthUser('existing.runner@example.com', 'password123', true);
    const user = userEvent.setup();
    render(<App />);

    await user.click(screen.getByRole('button', { name: 'Logowanie' }));
    await user.type(screen.getByLabelText('Email'), 'existing.runner@example.com');
    await user.type(screen.getByLabelText('Hasło'), 'password123');
    await user.click(screen.getByRole('button', { name: 'Zaloguj się' }));

    await waitFor(() => expect(screen.getByText(/Redirect:/)).toHaveTextContent('/dashboard'));
  });
});
