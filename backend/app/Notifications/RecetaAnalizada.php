<?php

namespace App\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;

class RecetaAnalizada extends Notification
{
    use Queueable;

    protected $receta;
    protected $estado; // 'aprobada' o 'rechazada'

    public function __construct($receta, $estado)
    {
        $this->receta = $receta;
        $this->estado = $estado;
    }

    public function via($notifiable)
    {
        // Enviaremos solo por mail por ahora. 
        // Puedes agregar 'database' si tienes la tabla 'notifications' creada.
        return ['mail']; 
    }

    public function toMail($notifiable)
    {
        $asunto = $this->estado === 'aprobada' 
            ? '¡Tu receta ha sido publicada!' 
            : 'Actualización sobre tu receta';

        $linea = $this->estado === 'aprobada'
            ? 'Felicidades, tu receta "' . $this->receta->titulo . '" ha pasado la moderación y ya es visible para todos.'
            : 'Tu receta "' . $this->receta->titulo . '" ha sido rechazada o puesta en revisión por nuestro equipo.';

        return (new MailMessage)
                    ->subject('NutriChef: ' . $asunto)
                    ->greeting('Hola ' . $notifiable->name)
                    ->line($linea)
                    ->action('Ir al Panel', url('/login'))
                    ->line('Gracias por ser parte de nuestra comunidad culinaria.');
    }
}