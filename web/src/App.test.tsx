import { render, screen, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import App from './App';
import { seedAuthUser } from './services/authService';

describe('App onboarding flows', () => {
  it('forces new user through legal consents and multi-step onboarding to dashboard', async () => {
    const user = userEvent.setup();
    render(<App />);

    await user.click(screen.getByRole('button', { name: 'Załóż konto' }));
    expect(await screen.findByText('Email jest wymagany.')).toBeInTheDocument();

    await user.type(screen.getByLabelText('Email'), 'new.runner@example.com');
    await user.type(screen.getByLabelText('Hasło'), 'password123');
    await user.type(screen.getByLabelText('Powtórz hasło'), 'password123');
    await user.click(screen.getByRole('button', { name: 'Załóż konto' }));

    expect(await screen.findByRole('heading', { name: /Regulamin, disclaimer/i })).toBeInTheDocument();
    await user.click(screen.getByLabelText(/Akceptuję regulamin platformy/i));
    await user.click(screen.getByLabelText(/Oświadczam, że biorę odpowiedzialność/i));
    await user.click(screen.getByLabelText(/Akceptuję politykę prywatności/i));
    await waitFor(() => expect(screen.getByRole('button', { name: /Akceptuję i kontynuuję/i })).toBeEnabled());
    await user.click(screen.getByRole('button', { name: /Akceptuję i kontynuuję/i }));

    expect(await screen.findByText(/Ankieta startowa/i)).toBeInTheDocument();
    await user.type(screen.getByLabelText('Wiek'), '31');
    await user.selectOptions(screen.getByLabelText('Płeć'), 'mężczyzna');
    await user.type(screen.getByLabelText('Waga (kg)'), '76.5');
    await user.type(screen.getByLabelText('Wzrost (cm)'), '182');
    await user.selectOptions(screen.getByLabelText('Typ sylwetki'), 'średni');
    await user.selectOptions(screen.getByLabelText('Historia aktywności'), 'regularnie');
    await user.click(screen.getByRole('button', { name: 'Dalej' }));

    await user.click(screen.getByRole('button', { name: 'Pon' }));
    await user.click(screen.getByRole('button', { name: 'Śr' }));
    await user.selectOptions(screen.getByLabelText('Cel'), 'biegać szybciej');
    await user.type(screen.getByLabelText('Docelowy dystans (opcjonalnie)'), '10');
    await user.type(screen.getByLabelText('Docelowy czas (opcjonalnie)'), '50:00');
    await user.click(screen.getByRole('button', { name: 'Dalej' }));

    await user.type(screen.getByLabelText('Nietolerancje pokarmowe (opcjonalnie)'), 'laktoza');
    await user.click(screen.getByRole('button', { name: 'gumy' }));
    await user.click(screen.getByRole('button', { name: /Zapisz i przejdź do dashboardu/i }));

    await waitFor(() => expect(screen.getByText(/Redirect:/)).toHaveTextContent('/dashboard'));
    expect(screen.getByText(/Profil biegacza/i)).toBeInTheDocument();
    expect(screen.getByText(/76.5 kg \/ 182 cm/i)).toBeInTheDocument();
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
