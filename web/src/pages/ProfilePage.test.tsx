import { render, screen, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { ProfilePage } from './ProfilePage';
import { seedAuthUser } from '../services/authService';

describe('ProfilePage', () => {
  const email = 'profile.test@example.com';
  const token = `mock-token-${email}`;

  beforeEach(() => {
    seedAuthUser(email, 'password123', true, true);
  });

  it('displays user profile data', async () => {
    render(<ProfilePage token={token} email={email} onLogout={() => {}} />);

    expect(await screen.findByText(/profile.test@example.com/)).toBeInTheDocument();
    expect(screen.getByText(/31/)).toBeInTheDocument();
    expect(screen.getByText(/76.5 kg/)).toBeInTheDocument();
    expect(screen.getByText(/laktoza/)).toBeInTheDocument();
  });

  it('allows editing profile fields', async () => {
    const user = userEvent.setup();
    render(<ProfilePage token={token} email={email} onLogout={() => {}} />);

    await screen.findByText(/profile.test@example.com/);
    await user.click(screen.getByRole('button', { name: 'Edytuj' }));

    const weightInput = screen.getByLabelText('Waga (kg)');
    await user.clear(weightInput);
    await user.type(weightInput, '82');

    await user.selectOptions(screen.getByLabelText('Cel'), 'schudnąć');
    await user.click(screen.getByRole('button', { name: 'Zapisz' }));

    await waitFor(() => expect(screen.getByText(/Profil zaktualizowany/)).toBeInTheDocument());
    expect(screen.getByText(/82 kg/)).toBeInTheDocument();
    expect(screen.getByText(/schudnąć/)).toBeInTheDocument();
  });

  it('changes password successfully', async () => {
    const user = userEvent.setup();
    render(<ProfilePage token={token} email={email} onLogout={() => {}} />);

    await screen.findByText(/profile.test@example.com/);
    await user.click(screen.getByRole('button', { name: 'Zmień hasło' }));

    await user.type(screen.getByLabelText('Aktualne hasło'), 'password123');
    await user.type(screen.getByLabelText('Nowe hasło'), 'newpass456');
    await user.type(screen.getByLabelText('Powtórz nowe hasło'), 'newpass456');
    await user.click(screen.getByRole('button', { name: 'Zmień hasło' }));

    await waitFor(() => expect(screen.getByText(/Hasło zostało zmienione/)).toBeInTheDocument());
  });

  it('shows error for wrong current password', async () => {
    const user = userEvent.setup();
    render(<ProfilePage token={token} email={email} onLogout={() => {}} />);

    await screen.findByText(/profile.test@example.com/);
    await user.click(screen.getByRole('button', { name: 'Zmień hasło' }));

    await user.type(screen.getByLabelText('Aktualne hasło'), 'wrongpassword');
    await user.type(screen.getByLabelText('Nowe hasło'), 'newpass456');
    await user.type(screen.getByLabelText('Powtórz nowe hasło'), 'newpass456');
    await user.click(screen.getByRole('button', { name: 'Zmień hasło' }));

    await waitFor(() => expect(screen.getByText(/Nieprawidłowe aktualne hasło/)).toBeInTheDocument());
  });

  it('calls onLogout when logout button clicked', async () => {
    const onLogout = vi.fn();
    const user = userEvent.setup();
    render(<ProfilePage token={token} email={email} onLogout={onLogout} />);

    await screen.findByText(/profile.test@example.com/);
    await user.click(screen.getByRole('button', { name: 'Wyloguj' }));

    expect(onLogout).toHaveBeenCalled();
  });
});
