import { render, screen, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import App from './App';
import { seedAuthUser } from './services/authService';

describe('App auth flows', () => {
  it('forces new user to accept legal consents before continuing', async () => {
    const user = userEvent.setup();
    render(<App />);

    await user.click(screen.getByRole('button', { name: 'Załóż konto' }));
    expect(await screen.findByText('Email jest wymagany.')).toBeInTheDocument();

    await user.type(screen.getByLabelText('Email'), 'new.runner@example.com');
    await user.type(screen.getByLabelText('Hasło'), 'password123');
    await user.type(screen.getByLabelText('Powtórz hasło'), 'password123');
    await user.click(screen.getByRole('button', { name: 'Załóż konto' }));

    expect(await screen.findByRole('heading', { name: /Regulamin, disclaimer i odpowiedzialność/i })).toBeInTheDocument();
    expect(screen.getByRole('button', { name: /Akceptuję i kontynuuję/i })).toBeDisabled();

    await user.click(screen.getByLabelText(/Akceptuję regulamin platformy/i));
    await user.click(screen.getByLabelText(/Oświadczam, że biorę odpowiedzialność/i));
    await user.click(screen.getByLabelText(/Akceptuję politykę prywatności/i));
    await user.click(screen.getByRole('button', { name: /Akceptuję i kontynuuję/i }));

    expect(await screen.findByText(/Redirect:/)).toHaveTextContent('/onboarding');
    expect(screen.getByText(/Zgody zaakceptowane:/)).toBeInTheDocument();
  });

  it('logs in existing user and shows dashboard redirect', async () => {
    seedAuthUser('existing.runner@example.com', 'password123', true, true);
    const user = userEvent.setup();
    render(<App />);

    await user.click(screen.getByRole('button', { name: 'Logowanie' }));
    await user.type(screen.getByLabelText('Email'), 'existing.runner@example.com');
    await user.type(screen.getByLabelText('Hasło'), 'password123');
    await user.click(screen.getByRole('button', { name: 'Zaloguj się' }));

    await waitFor(() => expect(screen.getByText(/Redirect:/)).toHaveTextContent('/dashboard'));
  });
});
